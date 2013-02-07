DvdLibrary.Views.FilmStripView = FilmStripView = Backbone.View.extend

  tagName: 'div'

  className: 'film-strip'

  initialize: ->
    @$el.html FilmStripView.template
    @leftThumbs  = @$('.thumbs.left')
    @rightThumbs = @$('.thumbs.right')

  render: ->

  setTitles: (titles) ->

  setPosition: (position) ->

  setBlindArea: (left, right) ->
    @leftThumbs.width  left
    @rightThumbs.width right


, # static members

  template: '
  <div class="shading top"/>
  <div class="shading bottom"/>
  <div class="thumbs left"/>
  <div class="thumbs right"/>
  '

