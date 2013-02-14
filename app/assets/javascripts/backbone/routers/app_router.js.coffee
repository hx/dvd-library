DvdLibrary.Routers.AppRouter = AppRouter = Backbone.Router.extend

  routes:
    'libraries/:library_id/titles(/*scope)' : 'titles_index'

  titles_index: (library_id, scope) ->
    model = DvdLibrary.Models.Library.getInstanceById library_id
    view = DvdLibrary.Views.LibraryView.getInstanceForModel model
    view.render new DvdLibrary.TitleScopeSet scope

$ ->
  DvdLibrary.router = new AppRouter
  Backbone.history.start pushState: true