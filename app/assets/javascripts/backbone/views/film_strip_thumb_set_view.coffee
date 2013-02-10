Views = DvdLibrary.Views

Views.FilmStripThumbSetView = FilmStripThumbSetView = Backbone.View.extend

  tagName: 'div'

  className: 'thumbs'

  initialize: (options) ->
    $.extend this, options
    $.extend this, FilmStripThumbSetView.sides[@side]
    @thumbViewListener = new DvdLibrary.EventDelegate 'changeAspectRatio', _.bind @positionThumbsFromView, this
    @$el.addClass @side

  render: ->

  layout: ->
    @setPosition @position || 0

  setTitles: (titles) ->
    if @titles
      @thumbViewListener.removeAll()
      @$el.children().detach()

    @titles = titles

    @layout()

  setPosition: (position) ->
    return unless @titles && @titles.length > 1

    @position = position

    @setFocusedTitle focusedTitle = Math.floor position

    expectedChildCount = @positionThumbs()

    childCount = @el.childNodes.length

    # remove any excess views from far edge
    while ++expectedChildCount < childCount
      view = @getThumbViewByDisplayIndex(expectedChildCount)
      @thumbViewListener.remove view
      view.$el.detach()

    @fetchNextTitle()

  positionThumbs: (index = 0) ->
    # ~0 means barely visible
    # ~1 means mostly visible
    fraction = @position - @focusedTitle

    # gap between thumbnails
    gap   = @el.offsetHeight * 16 / 264

    # width of container to populate (go over the edges a smidge)
    width = @el.offsetWidth  * 1.5

    # position thumbs from the center outwards
    nextPosition = if index == 0 then null else
      previousView = @getThumbViewByDisplayIndex(index - 1)
      parseFloat(previousView.el.style[@align]) + previousView.el.offsetWidth + gap

    while thumb = @getThumbViewByDisplayIndex(index++)
      thumb.layout()
      el = thumb.el
      elementWidth = el.offsetWidth + gap
      el.style[@align] = (position = nextPosition || (gap  - elementWidth * (fraction * @increment + @offset))) + 'px'
      break if position > width
      nextPosition = position + elementWidth

    index

  positionThumbsFromView: (view) ->
    index = 0
    childNodes = @el.childNodes
    while node = childNodes[index++]
      return @positionThumbs index if node == view.el

  setFocusedTitle: (focusedTitle) ->
    return if @focusedTitle == focusedTitle

    return @focusedTitle = focusedTitle if !@focusedTitle?

    if Math.abs(@focusedTitle - focusedTitle) > @el.childNodes.length
      @focusedTitle = focusedTitle
      @thumbViewListener.removeAll()
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
    @thumbViewListener.add view

  shift: ->
    view = @getThumbViewByTitle @titles[@focusedTitle += @increment]
    view.$el.detach()
    @thumbViewListener.remove view

  getThumbViewByDisplayIndex: (index = 0) ->
    view = @getThumbViewByTitle @titles[@focusedTitle + (index + 1) * @increment]
    if view
      view.el.style[@side] = ''
      unless view.el.parentNode
        @el.appendChild view.el
        @thumbViewListener.add view
    view

  getThumbViewByTitle: (title) ->
    title && Views.FilmStripThumbView.getInstanceForModel title

  fetchNextTitle: ->
    return if @fetching
    @fetching = true
    that = this
    $.each @el.childNodes, (i, node) =>
      model = node.view.model
      return  model.fetchAndThen -> that.fetchNextTitle() unless model.fetched() || model.fetching
    @fetching = false



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

