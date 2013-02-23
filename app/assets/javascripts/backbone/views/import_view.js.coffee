#= require ./dialog_view
#= require ./progress_bar_view

template = """
<p class="remaining-time">
    Remaining:
</p>
<ul class="links">
    <li><a href="javascript:" class="pause"  >Pause</a></li>
    <li><a href="javascript:" class="cancel" >Cancel</a></li>
    <li><a href="javascript:" class="details">Show details</a></li>
</ul>
<div class="details">
    <table cellspacing="0">
        <thead>
        <tr>
            <th>&nbsp;</th>
            <th scope="col">Total</th>
            <th scope="col">Accepted</th>
            <th scope="col">Rejected</th>
            <th scope="col">Remaining</th>
        </tr>
        </thead>
        <tbody>
        <tr class="files">
            <th scope="row">Files</th>
            <td class="total">0</td>
            <td class="accepted">0</td>
            <td class="rejected">0</td>
            <td class="remaining">0</td>
        </tr>
        <tr class="data">
            <th scope="row">Data</th>
            <td class="total">0</td>
            <td class="accepted">0</td>
            <td class="rejected">0</td>
            <td class="remaining">0</td>
        </tr>
        </tbody>
    </table>
    <div class="log"></div>
</div>
"""

dimensions =
  small: [362, 107]
  large: [409, 358]

sizeInKb = (bytes) -> (bytes / 0x400   ).toFixed(1) + 'kb'
sizeInMb = (bytes) -> (bytes / 0x100000).toFixed(2) + 'mb'

durationInMSS = (milliseconds) ->
  minutes = milliseconds / 60000
  Math.floor(minutes) + ':' + ('0' + Math.round(minutes % 1 * 60)).slice(-2)

fileGroupAdd = (file, skipRender) ->
  @files.push file
  @size += file.size
  @view.render() unless skipRender
  this

fileGroup = (view) ->
  _.extend ((file) -> arguments.callee.add file),
    add:   fileGroupAdd
    size:  0
    files: []
    view:  view

DvdLibrary.Views.ImportView = ImportView = DvdLibrary.Views.DialogView.extend

  dialogClassName: 'import'

  width:  dimensions.small[0]
  height: dimensions.small[1]

  events:
    'click a.details':  'toggleDetails'
    'click a.pause':    'clickPauseResume'
    'click a.cancel':   'clickCancel'

  initialize: ->
    @init()
    @setHeading "Importing to #{@model.get('name')}"
    @progressBar = new DvdLibrary.Views.ProgressBarView
    @$body.html(template).prepend @progressBar.el
    @$log = @$('.log')
    @$remaining = @$('.remaining-time')
    @files =
      accepted:  fileGroup(this)
      rejected:  fileGroup(this)
      succeeded: fileGroup(this)
      failed:    fileGroup(this)
    @statsRenderers =
      files: @statsRow('files', (->@files.length))
      data:  @statsRow('data' , (->@size), sizeInMb)

  statsRow: (rowClass, property, filter = (x) -> x) ->
    divs =
      total: 0
      accepted: 0
      rejected: 0
      remaining: 0
    files = @files
    prop = (x) -> property.call(x)
    for i of divs
      divs[i] = @$(".#{rowClass} .#{i}")
    ->
      divs.total.text     filter total = prop(files.accepted) + (rejected = prop(files.rejected))
      divs.accepted.text  filter succeeded = prop(files.succeeded)
      divs.rejected.text  filter rejected + (failed = prop(files.failed))
      divs.remaining.text filter total - succeeded - failed - rejected
      this

  toggleDetails: ->
    @$el.toggleClass 'with-details'
    showDetails = @$el.hasClass('with-details')
    @$('a.details').text(if showDetails then 'Hide details' else 'Show details')
    @setWidthAndHeight.apply this, dimensions[if showDetails then 'large' else 'small']

  acceptFile: (file) ->
    @files.accepted file
    true

  log: (message, type) ->
    el = @$log[0]
    $('<p>').appendTo(el).text(message).addClass(type || 'notice')
    el.scrollTop = el.scrollHeight
    this

  rejectFile: (file, reason) ->
    @files.rejected file
    @log "Rejected '#{file.name}' without sending: #{reason}", 'error'
    false

  uploadsStarted: ->
    @allStartedAt = new Date
    @log "Starting upload of #{@files.accepted.length} file(s) at #{@allStartedAt.toLocaleTimeString()}"

  uploadStarted: (file) ->
    @fileStartedAt = new Date
    @log "Sending '#{file.name}' (#{sizeInKb(file.size)})..."

  uploadProgressed: (file, progress) -> @render progress

  uploadSucceeded: (file, title) ->
    fileType = if file.type == 'text/xml' then 'title' else 'poster for'
    @log "Imported #{fileType} '#{title}' in #{@fileElapsed()}", 'success'
    @files.succeeded file, true

  uploadFailed: (file, errors) ->
    errorText = $.map(errors, (error)-> "[#{error.code}] #{error.message}").join("\n")
    @log "Failed after #{@fileElapsed()}:\n#{errorText}", 'error'
    @files.failed file, true

  clickPauseResume: ->
    @trigger 'pauseResume'

  clickCancel: ->
    if @finished
      @hide()
    else
      @trigger 'cancel'

  pause: (paused) ->
    return if @finished
    @paused = paused || false
    @$el.toggleClass 'paused', paused
    @$('.links .pause').text if paused then 'Resume' else 'Pause'
    if paused
      @_elapsed = @elapsed()
    else
      @allStartedAt = new Date
    @render()

  cancel: ->
    @showAsFinished()
    @$remaining.text "Cancelled after #{durationInMSS(@elapsed())}"

  uploadsFinished: ->
    @showAsFinished()
    @$remaining.text 'Finished in ' + durationInMSS(Date.now() - @allStartedAt)

  showAsFinished: ->
    @finished = true
    @$el.addClass 'finished'
    @$('.links .pause').parent().remove()
    @$('.links .cancel').text 'Close'

  elapsed: -> (Date.now() - @allStartedAt) + (@_elapsed || 0)

  fileElapsed: -> ((Date.now() - @fileStartedAt) / 1000).toFixed(1) + 'sec'

  render: (partialProgress = 0) ->
    files = @files
    @statsRenderers.files().data()
    progress = (files.succeeded.files.length + files.failed.files.length + partialProgress) / files.accepted.files.length
    @progressBar.progress progress
    if @paused
      remainingText = 'Paused'
    else
      remainingText = 'Remaining: '
      if @allStartedAt
        elapsed = @elapsed()
        remainingText += durationInMSS(elapsed / progress - elapsed) if elapsed > 0 && progress > 0
    @$remaining.text remainingText
