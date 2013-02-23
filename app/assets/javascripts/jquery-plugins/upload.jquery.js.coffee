buildMultiPart = (boundary, data) ->
  ret = ''
  for key, value of data
    body = value.data || unescape(encodeURIComponent(value))
    ret += "--#{boundary}\r\nContent-Disposition: form-data; name=\"#{key}\""
    ret += "; filename=\"#{value.name}\"" if value.name
    ret += "\r\nContent-Type: #{value.type || 'text/plain; charset=utf-8'}\r\n\r\n#{body}\r\n"
  "#{ret}--#{boundary}--\r\n"

xhrProto = XMLHttpRequest.prototype
sendAsBinary = xhrProto.sendAsBinary || (data) -> xhrProto.send.call this, (new Uint8Array(data)).buffer

$.upload = (files, options, callback) ->
  files = [files] unless files.push
  queue = files.slice()
  data = _.extend {}, options.data
  aborted = false
  xhr = null
  do next = ->
    return if aborted
    if file = queue.pop()
      reader = new FileReader
      reader.onloadend = ->
        data["files[#{files.length}]"] =
          name: file.name
          type: file.type
          data: reader.result
        next()
      reader.readAsBinaryString file
    else
      boundary = Math.random().toString(16).slice(2) + Date.now()
      body = buildMultiPart boundary, data
      xhr = $.ajax _.extend {}, options,
        type: 'POST'
        data: body
        processData: false
        headers:
          'Content-Type': "multipart/form-data; boundary=#{boundary}"
        xhr: ->
          x = $.ajaxSettings.xhr()
          x.send = sendAsBinary
          if x.upload && _.isFunction(options.progress)
            x.upload.addEventListener 'progress', (event) ->
              options.progress.call files, event.loaded / event.total if event.lengthComputable
            , false
          x
      callback.call xhr if _.isFunction(callback)
  abort: ->
    xhr?.abort()
    aborted = true
