$.fn.fitTextHeight = $.extend (proportion = 1, referencElement = null) ->

  callee = arguments.callee

  @each ->
    @proportionalHeight = proportion
    @proportionReferenceElement = $ referencElement || this
    @jqueryProxy = $ this
    callee.elements.push this unless this in callee.elements

  callee.fit()

, # function members

  fit: ->
    $.each @elements, ->
      if @jqueryProxy.parents().last().is 'html'
        @jqueryProxy.css fontSize: @proportionReferenceElement.height() * @proportionalHeight

  elements: []