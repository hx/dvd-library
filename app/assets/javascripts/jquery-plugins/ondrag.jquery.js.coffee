drop = (event) ->
  event = event.originalEvent || event
  event.preventDefault()
  data = @_drag
  data.dragging = false
  data.handlers.drop.call data.jquery, event.dataTransfer.files, event if _.isFunction(data.handlers.drop)
  false

enter = (event) ->
  event.preventDefault()
  data = @_drag
  if data.leaveTimeout
    clearTimeout data.leaveTimeout
    data.leaveTimeout = null
  unless data.dragging
    data.dragging = true
    data.handlers.over.call data.jquery if _.isFunction data.handlers.over

leave = (event) ->
  event.stopPropagation();
  data = @_drag
  unless !data.dragging || data.leaveTimeout
    data.leaveTimeout = setTimeout ->
      data.leaveTimeout = null
      data.dragging = false
      data.handlers.out.call data.jquery if _.isFunction data.handlers.out
    , 50

$.fn.onDrag = (handlers) ->
  @each -> @_drag =
    handlers: handlers || {}
    jquery: $(this)
  @on('drop',       drop )
  .on('dragover',   enter)
  .on('dragenter',  enter)
  .on('dragleave',  leave)
