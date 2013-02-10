DvdLibrary.Views.FilmStripThumbView = FilmStripThumbView = Backbone.View.extend

  tagName: 'div'

  className: 'thumb'

  initialize: ->
    @el.view = this
    @aspectRatio = .75
    @model.on 'change:poster', _.bind @render, this
    @render()

  render: ->
    poster = @model.posterElements.thumb
    if poster
      @el.innerHTML = ''
      @el.appendChild poster
      @aspectRatio = @model.posterRatio()
      @layout()
    else
      @el.innerHTML = FilmStripThumbView.posterlessTemplate @model.attributes
      $(@el.firstChild).fitTextHeight .08, @el


  layout: ->
    @el.style.width = (@el.offsetHeight * @aspectRatio) + 'px'

, # static members

  instances: {}

  getInstanceForModel: (model) ->
    @instances[model.id] ||= new this model: model

  posterlessTemplate: _.template '<div class="posterless"><%- title %></div>'