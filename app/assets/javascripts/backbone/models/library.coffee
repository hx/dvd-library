DvdLibrary.Models.Library = Library = Backbone.Model.extend

  initialize: ->

, # static methods

  getInstance: (id) ->
    (@instances ||= {})[id] ||= new this id: id
