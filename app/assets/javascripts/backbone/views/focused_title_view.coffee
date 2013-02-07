DvdLibrary.Views.FocusedTitleView = FocusedTitleView = Backbone.View.extend

  tagName: 'div'

  className: 'focused-title'

  initialize: ->
    @$el.html FocusedTitleView.template
    @posterContainer = @$ '.poster-container'
    @posterBackground = @$ '.poster-background'
    @$('.summary div').fitTextHeight()

  render: ->

  layout: ->
    @posterBackground.css DvdLibrary.Helpers.fitBoxWithinBox(
      @imageWidth() - 10
      @imageHeight() - 10
      @posterContainer.width()
      @posterContainer.height()
    )

  imageWidth: -> 500
  imageHeight: -> 750

, # static members

  template: $.trim '
    <div class="poster-container">
      <div class="poster-background">
        <div class="poster">
          <img />
        </div>
      </div>
    </div>
    <div class="summary">
      <div class="title-title">The Quick &amp; the Dead</div>
      <div class="title-director">by Joe McSucksalot</div>
      <div class="title-cast">with Russell Crowe, Leonardo DiCaprio and Sharon Stone</div>
    </div>
    '