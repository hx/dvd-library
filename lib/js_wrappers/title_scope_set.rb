class TitleScopeSet < Array

  @js = V8::Context.new
  @js.load File.join Rails.root, 'app/assets/javascripts/backbone/lib/scope_parser.js'

  def self.parse_scopes(scopeSet)
    @js['parseScopes'].call scopeSet
  end

  def initialize(scopeSet = nil)
    push scopeSet if scopeSet
  end

  def push(key, value = nil)
    if key.respond_to? :type
      super key
    else
      TitleScopeSet.parse_scopes(key + (value.nil? ? '' : '/' + value.to_s)).each { |scope| push scope }
    end
  end

  alias_method :'<<', :push

  def to_s
    join '/'
  end

  def by_type(*args)
    types = args.map(&:to_s)
    select { |scope| types.include? scope.type }
  end

end
