#= require ./upload.jquery

batchDefaults =
  filesPerRequest: 1
  before: {}
  after:  {}

defaultResume = -> @paused = false

class Batch
  pause:  -> @paused = @resume == defaultResume || @paused
  cancel: -> @cancelled = true; @oncancel?()
  resume: defaultResume

whenReady = (batch, method) ->
  return if batch.cancelled
  if batch.paused
    batch.resume = ->
      batch.paused = false
      batch.resume = defaultResume
      method()
  else
    method()
  !batch.paused

$.upload.batch = (files, options) ->
  uploader = null
  batch = new Batch
  batch.oncancel = -> uploader?.abort()
  options = $.extend {}, batchDefaults, options
  files = _.filter files, options.filter, this if _.isFunction(options.filter)
  filesForRequest = null
  uploadOptions = url: options.url
  uploadOptions.progress = (progress) -> options.progress.call batch, filesForRequest, progress if options.progress
  whenReady batch, ->
    options.before.all?.call batch
    whenReady batch, nextRequest = ->
      filesForRequest = files.splice 0, options.filesPerRequest
      if filesForRequest.length
        queue = filesForRequest.slice()
        do nextBeforeEach = ->
          if file = queue.shift()
            options.before.each?.call batch, file
            whenReady batch, nextBeforeEach
          else
            uploader = $.upload filesForRequest, uploadOptions, -> @done (response) ->
              queue = filesForRequest.slice()
              do nextAfterEach = ->
                if file = queue.shift()
                  options.after.each?.call batch, file, response
                  whenReady batch, nextAfterEach
                else
                  nextRequest()
      else
        options.after.all?.call batch
  batch
