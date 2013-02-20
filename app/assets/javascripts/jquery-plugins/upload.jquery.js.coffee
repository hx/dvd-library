dashdash = '--'
crlf = "\r\n"

buildMultiPart = (boundary, data) ->
  ret = ''
  for key, value of data
    ret += dashdash + boundary + crlf
    ret += "Content-Disposition: form-data; name=\"#{key}\""
    ret += "; filename=\"#{value.name}\"" if value.name
    ret += "#{crlf}Content-Type: #{value.type}" if value.type
    ret += crlf + crlf + value.data || value + crlf
  ret + dashdash + boundary + dashdash + crlf

$.upload = (files, options, callback) ->
  files = [files] unless files.push
  data = options.data || {}
  do next = ->
    if file = files.pop()
      reader = new FileReader
      reader.onloadend = ->
        data["files[#{files.length}]"] =
          name: file.name
          type: file.type
          data: reader.result
        next()
      reader.readAsBinaryString file
    else
      boundary = '------multipartformboundary' + (new Date).getTime()
      body = buildMultiPart boundary, data
      ret = $.ajax $.extend options,
        type: 'POST'
        data: (new Uint8Array(Array.prototype.map.call(body, (x) -> x.charCodeAt(0) & 0xff))).buffer
        processData: false
        headers:
          'Content-Type': "multipart/form-data; boundary=#{boundary}"
      callback.call ret if _.isFunction(callback)
