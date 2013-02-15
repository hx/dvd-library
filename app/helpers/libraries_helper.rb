module LibrariesHelper

  def search_suggestions(term)
    LibrariesHelper.search_suggestions term
  end

  def self.search_suggestions(term)
    term.strip!
    scopes = TitleScopeSet.new
    return scopes unless term.present?

    # search by title

    scopes.push 'search', term

    letters = term.downcase.gsub(/[^a-z]/, '')

    if letters.present?

      # sorting

      matcher = Regexp.new '^' + letters
      %w[title release-date production-year genre media-type runtime certification].each do |criteria|
        scopes.push 'sort', criteria if criteria.gsub('-', '') =~ matcher
      end

      # indexed entities

      [MediaType, Genre, Studio, Person].each do |klass|
        klass.find_by_partial_name(term, 3).each do |match|
          scopes.push klass.name.underscore.gsub('_', '-'), match.id
        end
      end unless term.length < 2

    end

    # years

    if term =~ /^(18|19|20)\d\d$/
      scopes.push 'production-year', term

    # dates

    elsif term.length >= 4
      date = Chronic.parse term, context: :past, endian_precedence: [:little, :middle]
      if date
        scopes.push 'release-date', date.strftime('%Y-%m-%d')
      end
    end

    # runtimes

    match = /^(<|>)(=?)\s*(\d{1,4})$/.match term
    unless match.nil?
      less = match[1] == '<'
      or_eq = match[2].present?
      runtime = match[3].to_i
      runtime += (less ? -1 : 1) unless or_eq
      limit = less ? 1 : 3000
      scopes.push 'runtime', "#{runtime}-#{limit}"
    end

    match = /^(\d{1,4})\s*(?:-|to)\s*(\d{1,4})$/i.match term
    scopes.push 'runtime', "#{match[1]}-#{match[2]}" unless match.nil?

    # certifications

    without_spaces = term.gsub(/\s+/, '')
    if without_spaces.present?
      matcher = Regexp.new '^' + without_spaces, true
      Title.all_certifications.select { |c| c.gsub(/\s+/, '') =~ matcher }.each do |c|
        scopes.push 'certification', c
      end
    end

    scopes
  end

end
