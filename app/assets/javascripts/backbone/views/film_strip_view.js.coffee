DvdLibrary.Views.FilmStripView = FilmStripView = Backbone.View.extend

  tagName: 'div'

  className: 'film-strip'

  initialize: ->
    @widthSetter = $('<div>', class: 'width-setter', html: '&nbsp;').appendTo 'body'
    @$el.html FilmStripView.template

  setScrollWidth: (width) ->
    @widthSetter.$el.width width


  render: ->

, # static members

  template: '
  <div class="shading top"/>
  <div class="shading bottom"/>
  <div class="thumbs left"/>
  <div class="thumbs right"/>
  '

