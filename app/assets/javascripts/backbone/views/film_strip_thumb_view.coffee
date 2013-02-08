DvdLibrary.Views.FilmStripThumbView = FilmStripThumbView = Backbone.View.extend

  tagName: 'div'

  className: 'thumb'

  initialize: ->
    unless @model.fetched()
      @$el.html(FilmStripThumbView.unfetchedTemplate @model.attributes)
      @$('.unfetched').fitTextHeight .08, @el

  render: ->

  layout: ->
    #todo use image proportions
    @$el.width @$el.height() / 1.5

, # static members

  instances: {}

  getInstanceForModel: (model) ->
    @instances[model.id] ||= new this model: model

  unfetchedTemplate: _.template '<div class="unfetched"><%- title %></div>'