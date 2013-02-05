Views = DvdLibrary.Views

Views.LibraryView = LibraryView = Backbone.View.extend

  tagName: 'div'

  className: 'library'

  initialize: ->
    @$el.appendTo 'body'
    @filmStripView = new Views.FilmStripView
    @render if @model

  render: (newScope) ->
    return if @scope == newScope

    #if @scope
      #todo deal with old scope

    @scope = newScope





, # static members

  getInstance: ->
    @instance || new this
