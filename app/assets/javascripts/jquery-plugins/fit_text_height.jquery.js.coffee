fitTextElements = []

$.fn.fitTextHeight = $.extend (proportion = 1, referencElement = null) ->
  @each ->
    @proportionalHeight = proportion
    @proportionReferenceElement = $ referencElement || this
    @jqueryProxy = $ this
    fitTextElements.push this unless this in fitTextElements

  arguments.callee.fit()

  this

, # function members

  fit: ->
    $.each fitTextElements, ->
      if @jqueryProxy.parents().last().is 'html'
        @jqueryProxy.css fontSize: @proportionReferenceElement.height() * @proportionalHeight
