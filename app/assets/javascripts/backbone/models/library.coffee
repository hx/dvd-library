scopeCache = {}
instances = {}

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

  urlRoot: 'libraries'

, # static methods

  getInstanceById: (id) ->
    instances[id] ||= new this id: id, name: DvdLibrary.Models.index.library[id]
