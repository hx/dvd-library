DvdLibrary.Models.Library = Library = Backbone.Model.extend

  initialize: ->

  getTitlesForScopes: (scopes, callback) ->
    scopes = scopes.toString()
    scopeCache = @scopeCache ||= {}
    if scopeCache[scopes]
      return if callback then callback(scopeCache[scopes]) else this
    path = "libraries/#{@id}/titles"
    path += '/' + scopes if scopes.length
    DvdLibrary.ajax(path)
      .done (response) ->
        scopeCache[scopes] = $.map response, (title_id) -> DvdLibrary.Models.Title.getInstanceById title_id
        callback scopeCache[scopes] if callback
    this

, # static methods

  getInstanceById: (id) ->
    (@instances ||= {})[id] ||= new this id: id
