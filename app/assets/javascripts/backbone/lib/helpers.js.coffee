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

  oxfordComma: ->
    args = Array.prototype.slice.apply arguments
    switch args.length
      when 0 then ''
      when 1 then args[0]
      when 2 then args[0] + ' and ' + args[1]
      else args[0..-2].join(', ') + ', and ' + args[-1..-1][0]

  months: $.trim("""
    January
    February
    March
    April
    May
    June
    July
    August
    September
    October
    November
    December
  """).split /\s+/
