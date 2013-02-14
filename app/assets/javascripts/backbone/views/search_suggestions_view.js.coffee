DvdLibrary.Views.SearchSuggestionsView = SearchSuggestionsView = Backbone.View.extend

  tagName: 'div'

  className: 'suggestions'

  initialize: ->
    @list = @$el
#    @$el.append @list = $ '<div>', class: 'list'

  layout: (width, fieldHeight) ->
    style = @el.style
    style.top = fieldHeight + 'px'
    style.right = (fieldHeight / 2) + 'px'
    style.left = (32 + fieldHeight / 1.26) + 'px'
    style.fontSize = (fieldHeight * .375) + 'px'
    lr = "#{fieldHeight / 5.25}px"
    @typeStyle =
      margin: "0 #{lr}"
      padding: "#{fieldHeight / 10}px 0"
    @suggestionStyle =
      padding: "#{lr} #{lr}"
      margin: "0 -#{lr}"
    @layoutChildren()

  layoutChildren: ->
    typeStyle = @typeStyle
    suggestionStyle = @suggestionStyle
    @$('.suggestion').each  -> $.extend this.style, suggestionStyle
    @$('.type').each        -> $.extend this.style, typeStyle

  render: (scopeSet) ->
    @list.empty()
    return unless scopeSet
    @suggestionViews = []
    $.each ['search', 'sort', 'filter', 'person'], (typeIndex, type) =>
      scopes = scopeSet.byType type
      return unless scopes.length
      container = $('<div>', class: "type #{type}").appendTo @list
      $.each scopes, (scopeIndex, scope) =>
        @suggestionViews.push suggestionView = new DvdLibrary.Views.SearchSuggestionView model: scope
        container[0].appendChild suggestionView.el
    @layoutChildren()

