DvdLibrary.Views.SearchFieldView = SearchFieldView = Backbone.View.extend

  tagName: 'div'

  className: 'search-field'

  initialize: ->
    @el.appendChild (@icon = new DvdLibrary.Views.SearchIconView).el
    @el.appendChild (@placeHolder = $('<div class="placeholder">Search</div>').fitTextHeight())[0]
    @$window = $ 'window'

  render: ->

  layout: (windowWidth, windowHeight) ->
    @$el.height height = windowHeight * 0.058333
    @placeHolder.css 'padding-left', height * 1.2
    @icon.layout()