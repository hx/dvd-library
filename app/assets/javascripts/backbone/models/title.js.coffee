DvdLibrary.Models.Title = Title = Backbone.Model.extend

  initialize: ->
    @posterElements =
      thumb:   null
      focused: null
    @on 'change:poster', ->
      posterUrl = @posterUrl()
      if posterUrl
        for i of @posterElements
          @posterElements[i] = element = new Image
          element.src = posterUrl
      return

  fetched: -> @has 'poster'

  fetch: ->
    return  if @fetching || @fetched()
    @fetching = true
    DvdLibrary.ajax(@url())
      .done _.bind @set, this

  fetchAndThen: (callback) ->
    return callback() if @fetched()
    that = this
    finished = ->
      that.off 'change', finished
      callback()
    @on 'change', finished
    @fetch()

  urlRoot: -> @get('library').url() + '/titles'

  posterRatio: ->
   size = @get('poster')?.size
   size && (size[0] / size[1])

  posterUrl: -> @get('poster')?.path


, # static members

  getInstanceById: (title_id) ->
    (@instances ||= {})[title_id] ||= new this
      id:    title_id
      title: DvdLibrary.Models.index.title[title_id]
