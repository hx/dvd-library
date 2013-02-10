DvdLibrary.EventDelegate = EventDelegate = (@event, @callback) ->
  $.extend this, Backbone.Events

$.extend EventDelegate.prototype,
  add:      (object)  -> @listenTo        object, @event, @callback
  remove:   (object)  -> @stopListening   object
  removeAll:          -> @stopListening()