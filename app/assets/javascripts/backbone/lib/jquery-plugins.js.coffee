$.fn.fitTextHeight = (proportion = 1) ->

  callee = arguments.callee

  elements = callee.elements ||= []

  callee.fit ||= ->
    $.each elements, ->
      $this = $ this
      $this.css fontSize: $this.height() * @proportionalHeight

  @each ->
    @proportionalHeight = proportion
    elements.push this if elements.indexOf(this) == -1

  callee.fit()