uploadFilesToLibrary = (files, library, options = {}) ->
  view = new DvdLibrary.Views.ImportView model: library
  view.on 'pauseResume', ->
    paused = !batch.paused
    batch[if paused then 'pause' else 'resume']()
    view.pause paused
  .on 'cancel', ->
    batch.cancel()
    view.cancel()
  .on 'hide', ->
    options.done?()

  batch = $.upload.batch Array.prototype.slice.call(files).sort((a, b) -> b.type.localeCompare a.type),
    url: library.url() + '/titles.json'
    filter: (file) ->
      if !file.name.match(/.+(f\.jpg|\.xml)$/i)
        view.rejectFile file, 'Not a supported file name'
      else if file.size > 0x200000
        view.rejectFile file, 'File is over 2mb'
      else
        view.acceptFile file
    before:
      each: (file) -> view.uploadStarted(file)
      all: -> view.show().uploadsStarted()
    after:
      each: (file, response) ->
        if response.errors.length
          view.uploadFailed file, response.errors
        else
          view.uploadSucceeded file, response.title.title
      all: -> view.uploadsFinished()
    progress: (files, progress) -> view.uploadProgressed files[0], progress

$.fn.makeImporterForLibrary = (library, options) ->

  @each ->
    thisLibrary = if _.isFunction(library) then library.call(this) else library
    thisLibrary = DvdLibrary.Models.Library.getInstanceById(thisLibrary) unless thisLibrary.id
    $(this).onDrag
      over:         -> @addClass    'dropping'
      out:          -> @removeClass 'dropping'
      drop: (files) -> @removeClass 'dropping'; uploadFilesToLibrary files, thisLibrary, options if files.length

  this
