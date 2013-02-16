Views = DvdLibrary.Views

Views.FilmStripView = FilmStripView = Backbone.View.extend

  tagName: 'div'

  className: 'film-strip'

  initialize: ->
    @$el.html FilmStripView.template

    @thumbs =
      right:  new Views.FilmStripThumbSetView(side: 'right')
      left:   new Views.FilmStripThumbSetView(side: 'left')

    @$el.append @thumbs.left.el, @thumbs.right.el

  render: ->

  setTitles: (titles) ->
    return if @titles == titles
    @titles = titles
    @thumbs.right.setTitles titles
    @thumbs.left.setTitles  titles

  setPosition: (position) ->
    return if @position == position
    @position = position
    @thumbs.right.setPosition position
    @thumbs.left.setPosition  position

  setBlindArea: (left, right) ->
    @thumbs.right.$el.width right
    @thumbs.left.$el.width  left

  layout: ->
    @thumbs.right.layout()
    @thumbs.left.layout()


, # static members

  template: '
  <div class="shading top"/>
  <div class="shading bottom"/>
  <div class="shutter top"/>
  <div class="shutter bottom"/>
  '

