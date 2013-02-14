labels =
  'media-type':       'Media'
  'release-date':     'Released'
  'production-year':  'Produced'

template = _.template """
  <div class="background">&#160;</div>
  <div class="value"><%= value %></div>
  <div class="label"><%= label %></div>
  <div class="clearFloats">&#160;</div>
  """

comparisonTemplate = _.template """
  <span class="comparision">
    <span class="lt">Before</span>
    <span class="lt e">or</span>
    <span class="e"><%= preposition %></span>
    <span class="gt e">or</span>
    <span class="gt">after</span>
  </span>
  <span class="value"><%= value %></span>
  """
DvdLibrary.Views.SearchSuggestionView = SearchSuggestionView = Backbone.View.extend

  tagName: 'div'

  className: 'suggestion'

  initialize: ->
    if @model instanceof DvdLibrary.TitleSortingScope
      x =
        value: "Sort by by #{$.capitalize @model.criteria}"
        label: 'Sort'

    else if @model instanceof DvdLibrary.TitleRuntimeScope
      x =
        value: "Between #{@model.min} and #{@model.max} minutes"
        label: 'Runtime'

    else if @model instanceof DvdLibrary.TitleSearchScope
      x =
        value: _.escape "Titles containing “#{@model.value}”"
        label: 'Search'

    else if @model instanceof DvdLibrary.TitleDateScope
      date = @model.value
      x =
        preposition: 'on'
        value: [
            date.getDate()
            DvdLibrary.Helpers.months[date.getMonth()].substr(0, 3)
            date.getFullYear()
          ].join ' '

    else if @model instanceof DvdLibrary.TitleComparisonScope
      x =
        preposition: 'in'

    else if @model instanceof DvdLibrary.TitleFilterScope
      x =
        value: DvdLibrary.Models.index[@model.property][@model.value]
      if @model.type == 'person'
        x.label = x.value.recent_role
        x.value = x.value.full_name

    else x = {}


    x.label ||= labels[@model.property] || $.capitalize @model.property
    x.value ||= _.escape @model.value
    x.value = comparisonTemplate x if x.preposition

    @el.innerHTML = template x

  focus: (focused) ->
    @$el.toggleClass 'focused', !!focused
