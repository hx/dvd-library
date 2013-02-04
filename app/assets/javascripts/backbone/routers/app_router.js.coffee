DvdLibrary = window.DvdLibrary
AppRouter =

  routes:
    'libraries/:id' : 'show_library'

  show_library: (id) ->
    console.debug "Library ##{id}"

AppRouter = DvdLibrary.Routers.AppRouter = Backbone.Router.extend AppRouter

$ ->
  window.DvdLibrary.router = new AppRouter
  Backbone.history.start pushState: true