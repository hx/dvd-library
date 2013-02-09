DvdLibrary.Views.FilmStripThumbView = FilmStripThumbView = Backbone.View.extend

  tagName: 'div'

  className: 'thumb'

  initialize: ->
    unless @model.fetched()
      @el.innerHTML = FilmStripThumbView.unfetchedTemplate @model.attributes
      $(@el.firstChild).fitTextHeight .08, @el

  render: ->

  layout: ->
    #todo use image proportions
    @el.style.width = (@el.offsetHeight / 1.5) + 'px'

, # static members

  instances: {}

  getInstanceForModel: (model) ->
    @instances[model.id] ||= new this model: model

  unfetchedTemplate: _.template '<div class="unfetched"><%- title %></div>'