ROWS = 5
GAP = 2

DvdLibrary.Views.ScopeTokenSetView = ScopeTokenSetView = Backbone.View.extend

  tagName: 'div'

  className: 'tokens'

  initialize: ->
    @tokenViews = {}

  render: (scopeSet) ->

    # ditch the old ones
    tokenViews = {}
    for key, view of @tokenViews
      if scopeSet.indexOf(key) >= 0
        tokenViews[key] = view
      else
        @removeView view

    @tokenViews = tokenViews
    @scopeSet = scopeSet

    # add the new ones
    newElements = []
    for scope in scopeSet.scopes
      scopeName = scope.toString()
      unless tokenViews[scopeName]
        tokenViews[scopeName] = view = new DvdLibrary.Views.ScopeTokenView model: scope
        @listenTo view, 'remove', (scope) => @trigger 'removeScope', scope
        @el.appendChild view.el
        newElements.push view.el

    @layout()

    $(newElements).addClass('visible')

  layout: ->
    columns = _.groupBy @scopeSet.scopes, (scope, index) -> Math.floor index / ROWS
    columnWidths = []
    height = @el.offsetHeight
    rightMargin = height / 8.6
    i = -1
    while column = columns[++i]
      views = _.map column, (scope) => @tokenViews[scope.toString()]
      columnWidths.push widths = [0, 0]
      for view in views
        widths[0] = Math.max widths[0], view.labelWidth()
        widths[1] = Math.max widths[1], view.valueWidth()
      for view, index in views
        view.el.style.top = (index * height / ROWS) + 'px'
        view.el.style.right = (rightMargin + widths[1] - view.valueWidth()) + 'px'

      rightMargin += widths[0] + widths[1] + 2 + height / 12

  removeView: (view) ->
    @stopListening view
    view.$el.removeClass 'visible'
    setTimeout (-> view.$el.remove()), 1000

