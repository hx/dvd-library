#= require_self
#= require_tree ./lib
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./collections
#= require_tree ./views
#= require_tree ./routers

@DvdLibrary =
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}
  ajax: (path, query = null) ->
    path += '.json'
    path += '?' + $.map(query, (k, v) -> encodeURIComponent(k) + '=' + encodeURIComponent(v)).join '&' if query
    $.ajax path

