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


$.capitalize = (text) ->
  text.replace /(^|[^a-z])([a-z])/gi, (all, space, letter) -> (space && ' ') + letter.toUpperCase()


titleUploaderDefaultOptions =
  allowedfiletypes: ['text/xml']
  maxfilesize:      1 # mb
  error:      ->
  dragOver:   -> @addClass    'dropping'
  dragLeave:  -> @removeClass 'dropping'
  drop:       -> @removeClass 'dropping'

$.fn.makeTitleUploader = (libraryId, options) ->
  @each ->
    $el = $(this)
    options = _.extend(options || {}, titleUploaderDefaultOptions)
    for i, v of options
      options[i] = _.bind(v, $el) if _.isFunction(v)
    options.url = "libraries/#{if _.isFunction(libraryId) then libraryId.call(this) else libraryId}/titles.json"
    $el.filedrop options

  this