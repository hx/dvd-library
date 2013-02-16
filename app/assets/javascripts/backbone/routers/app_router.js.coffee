DvdLibrary.Routers.AppRouter = AppRouter = Backbone.Router.extend

  routes:
    'libraries/:library_id/titles(/*scope)' : 'titlesIndex'

  titlesIndex: (library_id, scope) ->
    model = DvdLibrary.Models.Library.getInstanceById library_id
    view = DvdLibrary.Views.LibraryView.getInstanceForModel model

    if (view != @libraryView)
      @libraryView = view
      @listenTo view, 'changeScopeSet', (newScopeSet) =>
        @navigate "libraries/#{library_id}/titles/#{newScopeSet}", trigger: true

    scopeSet = new DvdLibrary.TitleScopeSet scope
    if scopeSet.toString() == scope
      view.render scopeSet
    else
      @navigate "libraries/#{library_id}/titles/#{scopeSet}", trigger: true, replace: true

$ ->
  DvdLibrary.router = new AppRouter
  Backbone.history.start pushState: true
