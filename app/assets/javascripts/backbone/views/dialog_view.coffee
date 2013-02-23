template = """
<div class="background">&nbsp;</div>
<div class="foreground">
  <h1></h1>
  <div class="body"></div>
</div>
"""

DvdLibrary.Views.DialogView = DialogView = Backbone.View.extend

  tagName: 'div'

  className: 'dialog'

  width: 400
  height: 200

  initialize: -> @init()

  init: ->
    @$el.html template
    @$el.addClass @dialogClassName if @dialogClassName
    @$heading = @$('h1')
    @$body = @$('.body')
    @setWidthAndHeight()

  setHeading: (text) ->
    @$heading.text text
    this

  show: ->
    unless @el.parentNode
      @$el.appendTo 'body'
      setTimeout ( => @$el.addClass('visible') ), 100
      @trigger 'show'
    this

  hide: ->
    if @el.parentNode
      @$el.removeClass('visible');
      setTimeout ( => @$el.remove()), 1000
      @trigger 'hide'
    this

  setWidth: (width) ->
    @setWidthAndHeight width

  setHeight: (height) ->
    @setWidthAndHeight null, height

  setWidthAndHeight: (width, height) ->
    @width  = width  || @width
    @height = height || @height
    @$('.foreground').css
      width:  @width
      height: @height
      marginLeft: @width  / -2 - 2
      marginTop:  @height / -2 - 2
    this
