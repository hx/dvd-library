require 'number_to_english'

class NameAndSeason

  attr_reader :name, :season

  def initialize(title)
    TITLE_PATTERNS.each do |pattern|
      if (match = title.match pattern)
        @name = match[1]
        if (season = match[2] || match[3])
          return @season = NUMBER_DICTIONARY[season.downcase.sub(' ', '-')] || season.to_i
        end
      end
    end
  end

  private

    NUMBER_DICTIONARY = {}

    (1..25).each { |n| [n.to_ordinal, n.to_cardinal].each { |s| NUMBER_DICTIONARY[s] = n } }

    number_pattern = '[1-9]|[012]\d|' + NUMBER_DICTIONARY.keys.map{ |key| key.sub('-', '[- ]') }.join('|')

    prefix_pattern = ':?\s*(?:-\s*)?(?:the\s+)?(?:(?:complete|entire)\s+)?'

    season_pattern = '(?:seasons?|series|volumes?|version)'

    TITLE_PATTERNS = %W|
      (.+?)#{prefix_pattern}(#{number_pattern})\s+#{season_pattern}
      (.+?)#{prefix_pattern}#{season_pattern}\s+(#{number_pattern})
      (.+?)#{prefix_pattern}\s+(#{number_pattern})\b
      ^#{prefix_pattern}([^:]+)
    |.map{ |p| Regexp.new(p, Regexp::IGNORECASE) }

end
