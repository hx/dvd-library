DvdLibrary.Views.SearchView = SearchView = Backbone.View.extend

  tagName: 'div'

  className: 'search'

  initialize: ->
    @el.appendChild (@searchField = new DvdLibrary.Views.SearchFieldView).el


  layout: (windowWidth, windowHeight) ->
    @$el.width Math.max(windowWidth / 3, windowHeight / 1.5)
    @searchField.layout.apply @searchField, arguments

