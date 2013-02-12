DvdLibrary.Views.SearchFieldView = SearchFieldView = Backbone.View.extend

  tagName: 'div'

  className: 'search-field'

  events:
    'click':        'focus'
    'blur input':   'blur'

  initialize: ->
    @el.appendChild (@icon = new DvdLibrary.Views.SearchIconView).el
    @el.appendChild (@placeHolder = $('<div class="placeholder">Search</div>').fitTextHeight())[0]
    @el.appendChild (@input = $('<input type="text"/>').fitTextHeight .5, @el)[0]
    @$window = $ 'window'

  render: ->

  layout: (windowWidth, windowHeight) ->
    @$el.height height = windowHeight * 0.058333
    @placeHolder.css 'padding-left', height * 1.2
    @input.css 'left', height * 1.2
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