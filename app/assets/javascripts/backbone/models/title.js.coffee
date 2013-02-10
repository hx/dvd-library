DvdLibrary.Models.Title = Title = Backbone.Model.extend

  initialize: ->
    @posterElements = []
    @on 'change:poster', ->
      posterUrl = @posterUrl()
      if posterUrl
        for i in [0..1]
          @posterElements[i] = element = document.createElement 'img'
          element.src = posterUrl

  fetched: -> @has 'cast'

  fetch: ->
    return  if @fetched()
    DvdLibrary.ajax(@url())
      .done _.bind @set, this

  urlRoot: -> @get('library').url() + '/titles'

  posterRatio: ->
   size = @get('poster')?.size
   size && (size[0] / size[1])

  posterUrl: -> @get('poster')?.path


, # static members

  getInstanceById: (title_id) ->
    (@instances ||= {})[title_id] ||= new this
      id:    title_id
      title: @titlesById[title_id]