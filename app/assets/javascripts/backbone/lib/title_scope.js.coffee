DvdLibrary.TitleScopeSet = class TitleScopeSet

  constructor: (scopeSet = '') ->
    @scopes = DvdLibrary.Helpers.parseScopes scopeSet

  toString: -> @scopes.join '/'

  byType: (type) ->
    $.grep @scopes, (scope) -> scope.type == type
