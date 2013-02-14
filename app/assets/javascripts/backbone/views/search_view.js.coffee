searchDelay = 250

Views = DvdLibrary.Views

Views.SearchView = SearchView = Backbone.View.extend

  tagName: 'div'

  className: 'search'

  initialize: (options) ->

    @library = options.library

    @el.appendChild (@searchField = new Views.SearchFieldView).el
    @el.appendChild (@suggestions = new Views.SearchSuggestionsView).el

    @searchField.on 'change',       _.bind @changeInput, this
    @searchField.on 'moveFocus',    _.bind @moveFocus, this
    @searchField.on 'changePhase',  _.bind @changePhase, this
    @searchField.on 'select',       _.bind @selectFocused, this
    @searchField.on 'blur',         _.bind @blurSuggestions, this

    @suggestions.on 'select',       _.bind @selectByScope, this

    @searchFor = null
    @searchTimeout = null

  changeInput: (newValue, force) ->
    return @searchFor = newValue if @searchFor? && !force
    @suggestions.blur()
    @searchFor = newValue
    clearTimeout @searchTimeout if @searchTimeout
    @searchTimeout = setTimeout =>
      @searchTimeout = null
      @library.getScopesForSearchTerm @searchFor, (scopeSet) =>
        return @changeInput @searchFor, true if @searchFor != newValue
        @searchFor = null
        @suggestions.render scopeSet
    , searchDelay

  layout: (windowWidth, windowHeight) ->
    @$el.width width = Math.max(windowWidth / 3.5, windowHeight / 1.75)
    fieldHeight = windowHeight * 0.058333
    @searchField.layout fieldHeight
    @suggestions.layout width, fieldHeight

  moveFocus: (amount) ->
    @suggestions.shiftFocusByOffset amount

  changePhase: (offset, event) ->
    event.preventDefault() if @suggestions.shiftPhaseByOffset offset

  selectFocused: ->
    @suggestions.selectFocused()

  selectByScope: (scope) ->
    @searchField.blur()
    @trigger 'selectScope', scope

  blurSuggestions: ->
    @suggestions.blur()