DvdLibrary.Helpers =

  fitBoxWithinBox: (innerWidth, innerHeight, outerWidth, outerHeight) ->
    if innerWidth/innerHeight > outerWidth/outerHeight
      width:  width  = outerWidth
      height: height = innerHeight/innerWidth * width
      left:   0
      top:    outerHeight/2 - height/2

    else
      height: height = outerHeight
      width:  width  = innerWidth/innerHeight * height
      top:    0
      left:   outerWidth/2 - width/2