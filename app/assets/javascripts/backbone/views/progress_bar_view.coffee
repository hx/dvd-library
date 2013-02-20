DvdLibrary.Views.ProgressBarView = ProgressBarView = Backbone.View.extend

  tagName: 'div'

  className: 'progress-bar'

  initialize: ->
    @$inner = $('<div class="inner"></div>').appendTo(@$el);
    @_progress = @options.progress || 0

  progress: (newValue) ->
    return @_progress unless newValue?
    @_progress = newValue
    @$inner.css width: (newValue * 100) + '%'
    this
