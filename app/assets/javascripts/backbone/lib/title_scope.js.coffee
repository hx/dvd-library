searchCache = {}

DvdLibrary.TitleScopeSet = class TitleScopeSet

  constructor: (scopeSet = '') ->
    @scopes = DvdLibrary.Helpers.parseScopes scopeSet

  toString: -> @scopes.join '/'

  byType: (type) ->
    $.grep @scopes, (scope) -> scope.type == type

  @forSearchTerm: (term, callback) ->
    return callback searchCache[term] if searchCache[term]
    DvdLibrary.ajax('suggestions', query: term)
      .done (response) ->
        $.extend DvdLibrary.Models.index.person, response.people if response.people
        callback searchCache[term] = new TitleScopeSet response.scopes
