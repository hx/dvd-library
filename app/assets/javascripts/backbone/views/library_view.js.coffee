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
      .append((@searchView = new Views.SearchView).el)

    @on 'resize', (width) ->
      @windowWidth = width
      @layout()

    @on 'scroll', (scrollLeft) ->
      @scrollLeft = scrollLeft
      @layout()

    @focusedTitleView.on 'changeAspectRatio', => @layout skip: 'focusedTitle'

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
      @setScrollWidth (@windowWidth ||= @el.offsetWidth) + @el.offsetWidth * (titles.length - 1) / 10

      @layout()

  setScrollWidth: (width) ->
    @widthSetter.width @scrollWidth = width

  layout: (options = {})->
    @searchView.layout @el.offsetWidth, @el.offsetHeight

    return unless @titles

    scrollPosition = @scrollLeft / (@scrollWidth - @windowWidth) || 0
    titlesPosition = Math.max 0, Math.min scrollPosition * @titles.length, @titles.length - 0.00001

    focusedTitleIndex = Math.floor titlesPosition

    unless options.skip == 'focusedTitle'
      @focusedTitleView.layout()
      @focusedTitleView.render @titles[focusedTitleIndex]

    blindArea = @focusedTitleView.blindArea()
    @filmStripView.setBlindArea blindArea.left, @windowWidth - blindArea.width - blindArea.left
    @filmStripView.setTitles    @titles
    @filmStripView.setPosition  titlesPosition if !isNaN titlesPosition
    @filmStripView.layout()

    $.fn.fitTextHeight.fit()



  setupTimers: ->
    metrics = => [
      @el.offsetWidth
      @el.offsetHeight
      window.scrollX
      window.scrollY
    ]
    [lastWidth, lastHeight, lastScrollLeft, lastScrollTop] = metrics()
    setInterval =>
      [width, height, scrollLeft, scrollTop] = newMetrics = metrics()

      if width != lastWidth || height != lastHeight
        @trigger 'resize', width, height, lastWidth, lastHeight

      if scrollLeft != lastScrollLeft || scrollTop != lastScrollTop
        @trigger 'scroll', scrollLeft, scrollTop, lastScrollLeft, lastScrollTop

      [lastWidth, lastHeight, lastScrollLeft, lastScrollTop] = newMetrics

    , 30

    @scrollLeft = lastScrollLeft
    @windowWidth = lastWidth

, # static members

  getInstance: ->
    @instance ||= new this
