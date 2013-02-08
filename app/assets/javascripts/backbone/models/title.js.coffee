DvdLibrary.Models.Title = Title = Backbone.Model.extend

  initialize: ->
    null

  fetched: -> @has 'barcode'

, # static members

  getInstanceById: (title_id) ->
    (@instances ||= {})[title_id] ||= new this
      id:    title_id
      title: @titlesById[title_id]