instances = {}

Views = DvdLibrary.Views

Views.LibraryView = LibraryView = Backbone.View.extend

  tagName: 'div'

  className: 'library loading'

  initialize: ->
    @setupTimers()

    @widthSetter = $('<div>', class: 'width-setter', html: '&nbsp;').appendTo 'body'

    @$el.appendTo('body')
      .append((@filmStripView = new Views.FilmStripView).el)
      .append((@focusedTitleView = new Views.FocusedTitleView).el)
      .append((@searchView = new Views.SearchView library: @model).el)
      .append((@scopeTokensView = new Views.ScopeTokenSetView ).el)

    @on 'resize', (width) ->
      @windowWidth = width
      @layout()

    @on 'scroll', (scrollLeft) ->
      @scrollLeft = scrollLeft
      @layout()

    @focusedTitleView.on 'changeAspectRatio', => @layout skip: 'focusedTitle'

    @searchView.on 'selectScope', _.bind @augmentScope, this

    @scopeTokensView.on 'removeScope', _.bind @removeScope, this

    @render if @model

  loading: (newValue) ->
    return @_loading unless newValue?
    @_loading = !!newValue
    @$el.toggleClass 'loading', newValue

  render: (newScopeSet) ->
    return if @scopeSet == newScopeSet

    @scopeSet = newScopeSet

    @focusedTitleView.render()

    @scopeTokensView.render newScopeSet

    @loading true

    @model.getTitlesForScopes newScopeSet, (titles) =>

      @loading false

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

    @scopeTokensView.layout()

  augmentScope: (newScope) ->
    @trigger 'changeScopeSet', @scopeSet.clone().augment newScope

  removeScope: (scope) ->
    @trigger 'changeScopeSet', @scopeSet.clone().remove scope

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

  getInstanceForModel: (model) ->
    instances[model.id] ||= new this model: model
