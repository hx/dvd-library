DvdLibrary.TitleScopeSet = class TitleScopeSet

  constructor: (scopeSet = '') ->
    @scopes = []
    offset = 0
    while offset < scopeSet.length && (next = TitleScopeSet.findNextPattern scopeSet, offset)
      [scope, pattern] = next
      offset += scope.length + 1
      @scopes.push pattern.factory.call this, pattern.leftRegex.exec(scope).slice 1


  @patterns: [
    pattern: '(r)?sort/(title|release-date|production-year|genre|media-type|runtime|certification)'
    factory: (reverse, field) -> new TitleSortingScope field, if reverse then 'desc' else 'asc'
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
    pattern: '(person|studio|media-type|genre)/(\\d+)',
    factory: (property, value) -> new TitleFilterScope property, parseInt(value, 10)
  ]

  for p in @patterns
    p.pattern += '(?=/|$)'
    p.midRegex = new RegExp '/' + p.pattern
    p.leftRegex = new RegExp '^' + p.pattern

  @findNextPattern: (scopeSet, offset) ->
    scopeSet = scopeSet.substr(offset) if offset
    for pattern in @patterns
      if match = pattern.leftRegex.exec scopeSet
        scope = match[0]
        until clean
          clean = true
          for other_pattern in @patterns
            if inner_match = other_pattern.midRegex.exec scope.substr 1
              scope = scope.substr 0, scope.indexOf inner_match[0]
              clean = false
        return [scope, pattern]
    false


DvdLibrary.TitleScope = class TitleScope

  constructor: (property, value) ->

DvdLibrary.TitleSortingScope = class TitleSortingScope extends TitleScope

  constructor: (criteria, direction) ->

DvdLibrary.TitleFilterScope = class TitleFilterScope extends TitleScope

  constructor: (property, value, comparison = '=') ->

DvdLibrary.TitleSearchScope = class TitleSearchScope extends TitleFilterScope

  constructor: (term) ->

DvdLibrary.TitleRuntimeScope = class TitleRuntimeScope extends TitleFilterScope

  constructor: (min, max) ->
    [min, max] = [max, min] if min > max
