DvdLibrary.Views.SearchFieldView = SearchFieldView = Backbone.View.extend

  tagName: 'div'

  className: 'search-field'

  events:
    'click':          'focus'
    'blur input':     'blur'
    'keyup input':    'change'
    'change input':   'change'
    'keydown input':  'key'


  initialize: ->
    @el.appendChild (@icon = new DvdLibrary.Views.SearchIconView).el
    @el.appendChild (@placeHolder = $('<div class="placeholder">Search</div>').fitTextHeight())[0]
    @el.appendChild (@input = $('<input type="text"/>').fitTextHeight .5, @el)[0]
    @lastValue = ''

  render: ->

  layout: (height) ->
    @el.style.height = height + 'px'
    @placeHolder[0].style.paddingLeft = (height * 1.2) + 'px'
    @input[0].style.left = (height * 1.2) + 'px'
    @icon.layout()

  focus: ->
    @$el.addClass 'focused'
    @input.focus().select()

  blur: ->
    return if @bluring
    @bluring = true
    @$el.removeClass 'focused'
    @input.blur()
    @bluring = false

  change: ->
    value = $.trim @input[0].value
    return if value == @lastValue
    @trigger 'change', @lastValue = value

  key: (event) ->
    switch event.keyCode
      when KeyEvent.DOM_VK_UP   then @trigger 'moveFocus', -1
      when KeyEvent.DOM_VK_DOWN then @trigger 'moveFocus', 1
      else return
    event.preventDefault()