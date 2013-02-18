DvdLibrary.Views.LibrariesView = LibrariesView = Backbone.View.extend

  initialize: ->
    @bindScaleToWindowHeight()
    @$('> li').each ->
      $li = $(@)
      id = /\d+/.exec(@id)[0]
      $(@).filedrop
        url: -> "libraries/#{id}/titles"
        allowedfiletypes: ['text/xml']
        error: ->
        dragOver:  -> $li.addClass    'dropping'
        dragLeave: -> $li.removeClass 'dropping'
        drop:      -> $li.removeClass 'dropping'


  bindScaleToWindowHeight: ->
    background = $('#background')[0]
    listStyle = @el.style
    props = 'webkitTransform mozTransform msTransform oTransform transform'.split ' '
    onResize = =>
      scale = "scale(#{background.offsetHeight / 900})"
      _.each props, (prop) -> listStyle[prop] = scale

    $(window).resize onResize
    onResize()

