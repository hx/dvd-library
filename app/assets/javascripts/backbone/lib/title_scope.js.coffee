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

  @forSearchTerm: (term, callback) ->
    return callback searchCache[term] if searchCache[term]
    DvdLibrary.ajax('suggestions', query: term)
      .done (response) ->
        $.extend DvdLibrary.Models.index.person, response.people if response.people
        callback searchCache[term] = new TitleScopeSet response.scopes
