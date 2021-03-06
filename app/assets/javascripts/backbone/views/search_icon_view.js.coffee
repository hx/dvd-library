DvdLibrary.Views.SearchIconView = SearchIconView = Backbone.View.extend

  tagName: 'div'

  className: 'icon'

  initialize: ->
    $('<img>', src: 'data:image/svg+xml,' + escape SearchIconView.graphic)
      .appendTo @el

  layout: ->
    @$el.width @el.offsetHeight

, # static members

  graphic: _.template("""
    <svg version="1.1" xmlns="http://www.w3.org/2000/svg" width="232px" height="232px">
      <circle <%= lineStyle %> cx="76" cy="76" r="64"/>
      <line   <%= lineStyle %> x1="121" y1="121" x2="220" y2="220" stroke-linecap="round"/>
    </svg> """,

      lineStyle: 'fill="none" stroke="#fff" stroke-width="24" stroke-miterlimit="10"'
    )
