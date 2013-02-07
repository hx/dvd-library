Views = DvdLibrary.Views

Views.LibraryView = LibraryView = Backbone.View.extend

  tagName: 'div'

  className: 'library'

  initialize: ->
    @setupTimers()

    @widthSetter = $('<div>', class: 'width-setter', html: '&nbsp;').appendTo 'body'

    @$el.appendTo('body')
      .append((@filmStripView = new Views.FilmStripView).el)
      .append((@focusedTitleView = new Views.FocusedTitleView).el)

    @on 'resize', (width) ->
      @windowWidth = width
      @layout()

    @on 'scroll', (scrollLeft) ->
      @scrollLeft = scrollLeft
      @layout()

    @render if @model

  render: (newScopeSet) ->
    return if @scopeSet == newScopeSet

    #if @scope
      #todo deal with old scope

    @scopeSet = newScopeSet

    @model.getTitlesForScopes newScopeSet, (titles) =>
      @titles = titles
      @filmStripView.setTitles titles

      # aim to have 10 thumbs on the screen
      @setScrollWidth @$el.width() * titles.length / 10

  setScrollWidth: (width) ->
    @widthSetter.width @scrollWidth = width

  layout: ->
    return unless @titles

    scrollPosition = @scrollLeft / (@scrollWidth - @windowWidth)
    titlesPosition = scrollPosition * @titles.length
    focusedTitleIndex = Math.round titlesPosition

    @focusedTitleView.layout()
    @focusedTitleView.render @titles[focusedTitleIndex]

    blindArea = @focusedTitleView.blindArea()
    @filmStripView.setBlindArea blindArea.left, @windowWidth - blindArea.width - blindArea.left

    $.fn.fitTextHeight.fit()



  setupTimers: ->
    $html = $('html')
    view = this
    metrics = -> [
      view.$el.width()
      view.$el.height()
      $html.scrollLeft()
      $html.scrollTop()
    ]
    [lastWidth, lastHeight, lastScrollLeft, lastScrollTop] = metrics()
    setInterval ->
      [width, height, scrollLeft, scrollTop] = newMetrics = metrics()

      if width != lastWidth || height != lastHeight
        view.trigger 'resize', width, height, lastWidth, lastHeight

      if scrollLeft != lastScrollLeft || scrollTop != lastScrollTop
        view.trigger 'scroll', scrollLeft, scrollTop, lastScrollLeft, lastScrollTop

      [lastWidth, lastHeight, lastScrollLeft, lastScrollTop] = newMetrics

    , 30

, # static members

  getInstance: ->
    @instance || new this
