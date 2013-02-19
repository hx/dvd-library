DvdLibrary.Views.LibrariesView = LibrariesView = Backbone.View.extend

  initialize: ->
    @bindScaleToWindowHeight()
    @$('> li').makeTitleUploader(-> /\d+/.exec(@id)[0])

  bindScaleToWindowHeight: ->
    background = $('#background')[0]
    listStyle = @el.style
    props = 'webkitTransform mozTransform msTransform oTransform transform'.split ' '
    onResize = =>
      scale = "scale(#{background.offsetHeight / 900})"
      _.each props, (prop) -> listStyle[prop] = scale

    $(window).resize onResize
    onResize()

