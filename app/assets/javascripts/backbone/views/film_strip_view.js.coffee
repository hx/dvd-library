DvdLibrary.Views.FilmStripView = FilmStripView = Backbone.View.extend

  tagName: 'div'

  className: 'film-strip'

  initialize: ->
    @widthSetter = $('<div>', class: 'width-setter', html: '&nbsp;').appendTo 'body'

  setScrollWidth: (width) ->
    @widthSetter.$el.width width


  render: ->

