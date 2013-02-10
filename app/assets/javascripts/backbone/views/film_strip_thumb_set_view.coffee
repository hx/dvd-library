Views = DvdLibrary.Views

Views.FilmStripThumbSetView = FilmStripThumbSetView = Backbone.View.extend

  tagName: 'div'

  className: 'thumbs'

  initialize: (options) ->
    $.extend this, options
    $.extend this, FilmStripThumbSetView.sides[@side]
    @$el.addClass @side

  render: ->

  layout: ->
    @setPosition @position || 0

  setTitles: (titles) ->
    if @titles
      @$el.children().detach()

    @titles = titles

    @layout()

  setPosition: (position) ->
    return unless @titles

    @position = position

    @setFocusedTitle focusedTitle = Math.floor position

    # ~0 means barely visible
    # ~1 means mostly visible
    fraction = position - focusedTitle

    # gap between thumbnails
    gap   = @$el.height() * 16 / 264

    # width of container to populate (go over the edges a smidge)
    width = @$el.width()  * 1.2

    # position thumbs from the center outwards
    index = 0
    nextPosition = null
    while thumb = @getThumbViewByDisplayIndex(index++)
      thumb.layout()
      el = thumb.el
      elementWidth = el.offsetWidth + gap
      el.style[@align] = (position = nextPosition || (gap - elementWidth * (fraction * @increment + @offset))) + 'px'
      break if position > width
      nextPosition = position + elementWidth

    childCount = @el.childNodes.length

    # remove any excess views from far edge
    while ++index < childCount
      @getThumbViewByDisplayIndex(index).$el.detach()


  setFocusedTitle: (focusedTitle) ->
    return if @focusedTitle == focusedTitle

    return @focusedTitle = focusedTitle if !@focusedTitle?

    if Math.abs(@focusedTitle - focusedTitle) > @el.childNodes.length
      @focusedTitle = focusedTitle
      @$el.children().detach()
      return

    while (@focusedTitle - focusedTitle) * @increment > 0
      @unshift()

    while (@focusedTitle - focusedTitle) * @increment < 0
      @shift()

    return

  unshift: ->
    view = @getThumbViewByTitle @titles[(@focusedTitle -= @increment) + @increment]
    @$el.prepend view.el

  shift: ->
    view = @getThumbViewByTitle @titles[@focusedTitle += @increment]
    view.$el.detach()

  getThumbViewByDisplayIndex: (index = 0) ->
    thumb = @getThumbViewByTitle @titles[@focusedTitle + (index + 1) * @increment]
    if thumb
      @el.appendChild thumb.el unless thumb.el.parentNode
      thumb.el.style[@side] = ''
    thumb

  getThumbViewByTitle: (title) ->
    title && Views.FilmStripThumbView.getInstanceForModel title

, # static members

  sides:
    right:
      align:        'left'
      increment:    1
      offset:       0

    left:
      align:        'right'
      increment:    -1
      offset:       1

