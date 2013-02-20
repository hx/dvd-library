uploadFilesToLibrary = (files, library) ->
  url = library.url() + '/titles.json'
  queue = []
  view = new DvdLibrary.Views.ImportView model: library
  $.each files, ->
    if !@name.match(/.+(f\.jpg|\.xml)$/i)
      view.rejectFile this, 'Not a supported file name'
    else if @size > 0x200000
      view.rejectFile this, 'File is over 2mb'
    else
      view.acceptFile this
      queue.push this
  view.show()

  do next = ->
    return unless file = queue.shift()
    view.uploadStarted file
    $.upload file,
      url: url
    , -> @done ->
      console.log this, arguments
      next()

$.fn.makeImporterForLibrary = (library) ->

  @each ->
    _library = if _.isFunction(library) then library.call(this) else library
    _library = DvdLibrary.Models.Library.getInstanceById(_library) unless _library.id
    $(this).onDrag
      over:         -> @addClass    'dropping'
      out:          -> @removeClass 'dropping'
      drop: (files) -> @removeClass 'dropping'; uploadFilesToLibrary files, _library

  return this
