DvdLibrary.Views.SearchIconView = SearchIconView = Backbone.View.extend

  tagName: 'div'

  className: 'search-icon'

  initialize: ->
    $('<img>', src: 'data:image/svg+xml,' + escape SearchIconView.graphic)
      .appendTo @el

  render: ->

, # static members

  graphic: _.template("""
    <!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
    <svg version="1.1" xmlns="http://www.w3.org/2000/svg" width="232px" height="232px">
      <circle <%= lineStyle %> cx="76" cy="76" r="64"/>
      <line   <%= lineStyle %> x1="121" y1="121" x2="220" y2="220" stroke-linecap="round"/>
    </svg> """,

      lineStyle: 'fill="none" stroke="#fff" stroke-width="24" stroke-miterlimit="10"'
    )
