$.capitalize = (text) ->
  text.replace /(^|[^a-z])([a-z])/gi, (all, space, letter) -> (space && ' ') + letter.toUpperCase()
