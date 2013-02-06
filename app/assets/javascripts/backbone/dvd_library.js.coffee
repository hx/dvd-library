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
  ajax: (path) -> $.ajax path + '.json'

