DvdLibrary = @DvdLibrary

DvdLibrary.Collections.ScopedTitleCollection = ScopedTitleCollection = Backbone.Collection.extend

  model: DvdLibrary.Models.Title

  initialize: ->

, # static members

  fromScope: (scope) ->