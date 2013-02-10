DvdLibrary.Views.FocusedTitleView = FocusedTitleView = Backbone.View.extend

  tagName: 'div'

  className: 'focused-title'

  initialize: ->
    @$el.html FocusedTitleView.template
    @posterContainer =  @$ '.poster-container'
    @posterBackground = @$ '.poster-background'
    @poster =           @$ '.poster'
    @posterImages = {}
    @labels = {}
    $.each ['title', 'director', 'cast'], (x, i) => @labels[i] = @$ '.title-' + i
    @$('.summary div').fitTextHeight()

  render: (model) ->
    if model != @model
      @stopListening @model if @model
      @model = model
      @listenTo model, 'change', _.bind(@render, this)
      @model.fetch()

    if @model
      @labels.title.text model.get 'title'
      director = model.get 'director'
      @labels.director.text if director then 'by ' + director else ''
      cast = DvdLibrary.Helpers.oxfordComma.apply this, model.get 'cast'
      @labels.cast.text if cast then 'with ' + cast else ''
      poster = @model.posterElements[1]
      @poster.toggleClass 'missing', !poster
      if poster
        @poster.children().detach()
        @poster[0].appendChild poster

    @layout()



  layout: ->
    aspectRatio = @aspectRatio()
    @posterBackground.css DvdLibrary.Helpers.fitBoxWithinBox(
      aspectRatio
      1
      @posterContainer[0].offsetWidth
      @posterContainer[0].offsetHeight
    )
    if @oldAspectRatio && @oldAspectRatio != aspectRatio
      @trigger 'changeAspectRatio'
    @oldAspectRatio = aspectRatio

  aspectRatio: -> @model && @model.posterRatio() || .75

  blindArea: ->
    left:  @posterBackground[0].offsetLeft + @posterContainer[0].offsetLeft
    width: @posterBackground[0].offsetWidth

, # static members

  template: $.trim '
    <div class="poster-container">
      <div class="poster-background">
        <div class="poster missing">
        </div>
      </div>
    </div>
    <div class="summary">
      <div class="title-title"></div>
      <div class="title-director"></div>
      <div class="title-cast"></div>
    </div>
    '