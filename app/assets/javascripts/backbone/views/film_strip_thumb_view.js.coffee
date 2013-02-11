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
      #@el.innerHTML = ''
      @el.appendChild poster
      oldAspectRatio = @aspectRatio
      @aspectRatio = @model.posterRatio()
      @layout()
      @trigger 'changeAspectRatio', this if oldAspectRatio != @aspectRatio
    else
      @el.innerHTML = FilmStripThumbView.posterlessTemplate @model.attributes
      $(@el.firstChild).fitTextHeight .08, @el


  layout: ->
    width = Math.round @el.offsetHeight * @aspectRatio
    return if width == @lastWidth
    @el.style.width = width + 'px'
    @lastWidth = width

, # static members

  instances: {}

  getInstanceForModel: (model) ->
    @instances[model.id] ||= new this model: model

  posterlessTemplate: _.template '<div class="posterless"><%- title %></div>'