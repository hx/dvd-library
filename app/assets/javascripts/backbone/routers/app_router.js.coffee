Dvdlibrary = window.Dvdlibrary
AppRouter =

  routes:
    'libraries/:id' : 'show_library'

  show_library: (id) ->
    console.debug "Library ##{id}"

AppRouter = Dvdlibrary.Routers.AppRouter = Backbone.Router.extend AppRouter

$ ->
  window.Dvdlibrary.router = new AppRouter
  Backbone.history.start pushState: true