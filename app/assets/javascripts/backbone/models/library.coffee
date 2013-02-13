scopeCache = {}
instances = {}
searchCache = {}

DvdLibrary.Models.Library = Library = Backbone.Model.extend

  getTitlesForScopes: (scopes, callback) ->
    library = this
    scopes = scopes.toString()
    if scopeCache[scopes]
      return if callback then callback(scopeCache[scopes]) else library
    path = @url() + '/titles'
    path += '/' + scopes if scopes.length
    DvdLibrary.ajax(path)
      .done (response) ->
        scopeCache[scopes] = $.map response, (title_id) -> DvdLibrary.Models.Title.getInstanceById(title_id).set(library: library)
        callback scopeCache[scopes] if callback
    library

  getScopesForSearchTerm: (term, callback) ->
    return callback searchCache[term] if searchCache[term]
    DvdLibrary.ajax(@url() + '/search', query: term)
      .done (response) ->
        $.extend DvdLibrary.Models.index, response.people if response.people
        callback searchCache[term] = new DvdLibrary.TitleScopeSet response.scopes

  urlRoot: 'libraries'

, # static methods

  getInstanceById: (id) ->
    instances[id] ||= new this id: id
