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
    @input.blur().val ''
    @trigger 'blur'
    @bluring = false

  change: ->
    value = $.trim @input[0].value
    return if value == @lastValue
    @trigger 'change', @lastValue = value

  key: (event) ->
    return if event.ctrlKey || event.shiftKey || event.altKey || event.metaKey

    keyCode = event.keyCode
    codes = KeyEvent

    if keyCode == codes.DOM_VK_RETURN
      @trigger 'select'

    else if keyCode == codes.DOM_VK_ESCAPE
      @blur()

    else if keyCode in [codes.DOM_VK_UP, codes.DOM_VK_DOWN]
      @trigger 'moveFocus', if keyCode == codes.DOM_VK_UP then -1 else 1
      event.preventDefault()

    else if keyCode in [codes.DOM_VK_LEFT, codes.DOM_VK_RIGHT]
      @trigger 'changePhase', (if keyCode == codes.DOM_VK_LEFT then -1 else 1), event

    return