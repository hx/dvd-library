Views = DvdLibrary.Views

Views.LibraryView = LibraryView = Backbone.View.extend

  tagName: 'div'

  className: 'library'

  initialize: ->
    @setup_timers()

    @$el.appendTo('body')
      .append((@filmStripView = new Views.FilmStripView).el)
      .append((@focusedTitleView = new Views.FocusedTitleView).el)

    @on 'resize', ->
      @focusedTitleView.layout()
      $.fn.fitTextHeight.fit()

    @render if @model

  render: (newScopeSet) ->
    return if @scopeSet == newScopeSet

    #if @scope
      #todo deal with old scope

    @scopeSet = newScopeSet

    @model.getTitlesForScopes newScopeSet, (titles) ->
      #todo render titles

  setup_timers: ->
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

    , 40

, # static members

  getInstance: ->
    @instance || new this
