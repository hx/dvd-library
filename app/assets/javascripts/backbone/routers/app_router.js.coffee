DvdLibrary.Routers.AppRouter = AppRouter = Backbone.Router.extend

  routes:
    'libraries/:library_id/titles(/*scope)' : 'titles_index'

  titles_index: (library_id, scope) ->
    view = DvdLibrary.Views.LibraryView.getInstance()
    view.model = DvdLibrary.Models.Library.getInstance library_id
    view.render scope

$ ->
  DvdLibrary.router = new AppRouter
  Backbone.history.start pushState: true