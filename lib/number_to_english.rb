# port of my old PHP converter, which is a port of my ancient Visual Basic converter. - Neil

module NumberToEnglish

  ORDINALS = {
      'one' => 'first',
      'two' => 'second',
      'ree' => 'ird',
      'ive' => 'ifth',
      't'   => 'th',
      'ine' => 'inth',
      'lve' => 'lfth',
      'y'   => 'ieth',
      ''    => 'th'
  }

  ORDINALS_PATTERN = Regexp.new('(' + ORDINALS.keys.join('|') + ')$')

  DICTIONARY = {
      0  => 'zero',
      1  => 'one',
      2  => 'two',
      3  => 'three',
      4  => 'four',
      5  => 'five',
      6  => 'six',
      7  => 'seven',
      8  => 'eight',
      9  => 'nine',
      10 => 'ten',
      11 => 'eleven',
      12 => 'twelve',
      13 => 'thirteen',
      14 => 'fourteen',
      15 => 'fifteen',
      16 => 'sixteen',
      17 => 'seventeen',
      18 => 'eighteen',
      19 => 'nineteen',
      20 => 'twenty',
      30 => 'thirty',
      40 => 'forty',
      50 => 'fifty',
      60 => 'sixty',
      70 => 'seventy',
      80 => 'eighty',
      90 => 'ninety'
  }

  THOUSANDS = %w[thousand] + %w[
      m b tr quadr quint sext sept oct non dec undec duodec tredec
	    quattuordec quindec sexdec septemdec octodec novemdec vigint
    ].map{ |p| p + 'illion' }

  def self.cardinal(number)
    number   = number.to_f unless number.is_a? Numeric
    negative = number < 0
    number   = number.abs
    fraction = fraction[1] if fraction = number.to_s.match(/\.(\d+)/)
    number   = number.floor
    if number == 0
      ret = DICTIONARY[0]
    else
      triplet_groups = []
      while number > 0
        triplet_groups.push number % 1000
        number = (number / 1000).floor
      end
      phrases = []
      triplet_groups.each_with_index do |triplet_value, thousands_exponent|
        if triplet_value > 0
          phrase = triplet_value >= 100 ? DICTIONARY[(triplet_value / 100).floor] + ' ' : ''
          triplet_value %= 100
          if triplet_value > 0
            phrase << 'hundred and ' unless phrase.empty?
            if triplet_value < 20
              phrase << DICTIONARY[triplet_value]
            else
              phrase << DICTIONARY[triplet_value - triplet_value % 10]
              phrase << '-' + DICTIONARY[triplet_value % 10] unless triplet_value % 10 == 0
            end
          else
            phrase << 'hundred'
          end
          phrases.unshift [thousands_exponent, phrase]
        end
      end
      ret = ''
      phrases.each do |phrase|
        thousands_exponent = phrase[0]
        ret << 'and ' if triplet_groups[0] < 100 && !ret.empty? && thousands_exponent == 0
        ret << phrase[1] + ' '
        if thousands_exponent == phrases.last[0]
          ret << THOUSANDS[thousands_exponent - 1] if thousands_exponent > 0
        elsif thousands_exponent > 0
          ret << THOUSANDS[thousands_exponent - 1]
          ret << ',' unless thousands_exponent == phrases[-2][0] && phrases[0][0] > 0 && triplet_groups[0] < 100
          ret << ' '
        end
      end
      ret = "negative #{ret}" if negative
      ret.strip!
    end
    ret << ' point ' + fraction.chars.to_a.map{ |c| DICTIONARY[c.to_i] }.join(' ') if fraction && fraction != '0'
    ret
  end

  def self.ordinal(number)
    self.cardinal(number.respond_to?(:sub) ? number.sub(/\..+/, '') : number.floor).sub(ORDINALS_PATTERN) { ORDINALS[$1] }
  end

end

class Numeric
  def to_cardinal; NumberToEnglish.cardinal self end
  def to_ordinal;  NumberToEnglish.ordinal  self end
end

if $0 == __FILE__
  puts 'Running tests...'
  {
      0 => 'zero',
      1 => 'one',
      5 => 'five',
      10 => 'ten',
      99 => 'ninety-nine',
      100 => 'one hundred',
      101 => 'one hundred and one',
      120 => 'one hundred and twenty',
      999 => 'nine hundred and ninety-nine',
      2000 => 'two thousand',
      4096 => 'four thousand and ninety-six',
      8600 => 'eight thousand, six hundred',
      502220080004 => 'five hundred and two billion, two hundred and twenty million, eighty thousand and four',
      -1 => 'negative one',
      -45.26 => 'negative forty-five point two six'

  }.each do |num, word|
    result = num.to_cardinal
    puts "#{num}: expected '#{word}', got '#{result}'" unless word == result
  end
  puts 'Done.'
end
