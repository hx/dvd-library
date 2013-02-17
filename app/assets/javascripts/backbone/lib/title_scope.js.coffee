searchCache = {}

DvdLibrary.TitleScopeSet = class TitleScopeSet

  constructor: (scopeSet = '') ->
    @augment scopeSet

  toString: -> @scopes?.join('/') || ''

  byType: (type) -> _.where @scopes, type: type

  clone: -> new TitleScopeSet @toString()

  augment: (newScope) ->
    @scopes = DvdLibrary.Helpers.parseScopes _.compact([@toString(), newScope.toString()]).join '/'
    this

  indexOf: (scope) ->
    scope = scope.toString()
    for value, index in @scopes
      return index if value.toString() == scope
    -1

  remove: (scope) ->
    scope = scope.toString()
    index = @indexOf scope
    @scopes.splice index, 1 unless index < 0
    this

  @forSearchTerm: (term, callback) ->
    return callback searchCache[term] if searchCache[term]
    DvdLibrary.ajax('suggestions', query: term)
      .done (response) ->
        $.extend DvdLibrary.Models.index.person, response.people if response.people
        callback searchCache[term] = new TitleScopeSet response.scopes
