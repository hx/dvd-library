#= require ./dialog_view
#= require ./progress_bar_view

template = """
<p class="remaining-time">
    Remaining:
    <span class="value">um...</span>
</p>
<ul class="links">
    <li><a href="javascript:" class="cancel">Cancel</a></li>
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

sizeInKb = (bytes) -> (bytes / 0x400).toFixed(1) + 'kb'

DvdLibrary.Views.ImportView = ImportView = DvdLibrary.Views.DialogView.extend

  dialogClassName: 'import'

  width:  dimensions.small[0]
  height: dimensions.small[1]

  events:
    'click a.details': 'toggleDetails'

  initialize: ->
    @init()
    @setHeading "Importing to #{@model.get('name')}"
    @progressBar = new DvdLibrary.Views.ProgressBarView
    @$body.html(template).prepend @progressBar.el
    @$log = @$('.log')
    @files =
      total: []
      succeeded: []
      failed: []
    @totalBytes = 0
    @rejectedFileCount = 0

  toggleDetails: ->
    @$el.toggleClass 'with-details'
    showDetails = @$el.hasClass('with-details')
    @$('a.details').text(if showDetails then 'Hide details' else 'Show details')
    @setWidthAndHeight.apply this, dimensions[if showDetails then 'large' else 'small']

  acceptFile: (file) ->
    @files.total.push file
    @totalBytes += file.size
    true

  log: (message, type) ->
    el = @$log[0]
    scroll = el.scrollTop == el.scrollHeight
    $('<p>').appendTo(el).text(message).addClass(type || 'notice')
    el.scrollTop = el.scrollHeight if scroll
    this

  rejectFile: (file, reason) ->
    ++@rejectedFileCount
    @log "Rejected '#{file.name}' without sending: #{reason}", 'error'
    false

  uploadsStarted: ->
    @allStartedAt = new Date
    @log "Starting upload of #{@files.total.length} file(s) at #{@allStartedAt.toLocaleTimeString()}"

  uploadStarted: (file) ->
    @fileStartedAt = new Date()
    @log "Sending '#{file.name}' (#{sizeInKb(file.size)})..."

  uploadProgressed: (file, progress) ->

  uploadSucceeded: (file, title) ->
    fileType = if file.type == 'text/xml' then 'title' else 'poster for'
    elapsed = ((Date.now() - @fileStartedAt) / 1000).toFixed(1)
    @log "Imported #{fileType} '#{title}' in #{elapsed}sec", 'success'

  uploadFailed: (file, errors) ->
    elapsed = ((Date.now() - @fileStartedAt) / 1000).toFixed(1)
    errorText = $.map(errors, (error)-> "[#{error.code}] #{error.message}").join("\n")
    @log "Failed after #{elapsed}sec:\n#{errorText}", 'error'