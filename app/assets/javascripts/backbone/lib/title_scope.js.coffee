DvdLibrary.TitleScopeSet = class TitleScopeSet

  constructor: (scopeSet = '') ->
    @scopes = []
    offset = 0
    while offset < scopeSet.length && (next = TitleScopeSet.findNextPattern scopeSet, offset)
      [scope, pattern] = next
      offset += scope.length + 1
      @scopes.push pattern.factory.apply this, pattern.leftRegex.exec(scope).slice 1

  toString: -> @scopes.join '/'

  @patterns: [
    pattern: '(r)?sort/(title|release-date|production-year|genre|media-type|runtime|certification)'
    factory: (reverse, field) -> new TitleSortingScope field, reverse
  ,
    pattern: 'search/(.+)'
    factory: (term) -> new TitleSearchScope term
  ,
    pattern: 'runtime/(\\d+)-(\\d+)'
    factory: (min, max) -> new TitleRuntimeScope parseInt(min, 10), parseInt(max, 10)
  ,
    pattern: '(certification)/(.*)'
    factory: (property, value) -> new TitleFilterScope property, value
  ,
    pattern: '(person|studio|media-type|genre)/(\\d+)'
    factory: (property, value) -> new TitleFilterScope property, parseInt(value, 10)
  ,
    pattern: '(production-year)(?:-([lg]te?))?/(\\d{4})'
    factory: (property, comparison, value) -> new TitleComparisonScope property, parseInt(value, 10), comparison
  ,
    pattern: '(release-date)(?:-([lg]te?))?/(\\d{4})-(\\d{2})-(\\d{2})'
    factory: (property, comparison, year, month, day) ->
      new TitleDateScope property, new Date(parseInt(year, 10), parseInt(month, 10) - 1, parseInt(day, 10)), comparison
  ]

  @findNextPattern: (scopeSet, offset) ->
    scopeSet = scopeSet.substr(offset) if offset
    for pattern in @patterns
      if match = pattern.leftRegex.exec scopeSet
        scope = match[0]
        for other_pattern in @patterns
          if inner_match = other_pattern.midRegex.exec scope.substr 1
            scope = scope.substr 0, scope.indexOf inner_match[0]
        return [scope, pattern]
    false


  for p in @patterns
    p.pattern += '(?=/|$)'
    p.midRegex = new RegExp '/' + p.pattern
    p.leftRegex = new RegExp '^' + p.pattern


DvdLibrary.TitleScope = class TitleScope

DvdLibrary.TitleSortingScope = class TitleSortingScope extends TitleScope

  constructor: (@criteria, reverse) ->
    @reverse = !!reverse

  toString: -> (if @reverse then 'r' else '') + 'sort/' + @criteria

DvdLibrary.TitleFilterScope = class TitleFilterScope extends TitleScope

  constructor: (@property, @value) ->

  toString: -> @property + '/' + @value

DvdLibrary.TitleSearchScope = class TitleSearchScope extends TitleFilterScope

  constructor: (@term) ->

  toString: -> 'search/' + @term

DvdLibrary.TitleRuntimeScope = class TitleRuntimeScope extends TitleFilterScope

  constructor: (min, max) ->
    [min, max] = [max, min] if min > max

  toString: -> "runtime/#{@min}-#{@max}"

DvdLibrary.TitleComparisonScope = class TitleComparisonScope extends TitleFilterScope

  constructor: (@property, @value, @comparison) ->

  toString: -> @property + (if @comparison then '-' + @comparison else '') + '/' + @valueAsString()

  valueAsString: -> @value

DvdLibrary.TitleDateScope = class TitleDateScope extends TitleComparisonScope

  valueAsString: -> @value.toISOString().substr(0, 10)



