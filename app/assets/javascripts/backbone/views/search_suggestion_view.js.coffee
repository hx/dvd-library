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
  <span class="comparison">
    <span class="lt">Before</span>
    <span class="lte">or</span>
    <span class="e"><%= preposition %></span>
    <span class="gte">or</span>
    <span class="gt">after</span>
  </span>
  <span class="value"><%= value %></span>
  """

phases = ['lt', 'lte', 'e', 'gte', 'gt']

DvdLibrary.Views.SearchSuggestionView = SearchSuggestionView = Backbone.View.extend

  tagName: 'div'

  className: 'suggestion'

  events:
    'mouseover .comparison span': 'setPhaseByEvent'

  initialize: ->
    if @model.type == 'sort'
      x =
        value: "Sort by by #{$.capitalize @model.criteria}"
        label: 'Sort'

    else if @model.property == 'runtime'
      x =
        value: "Between #{@model.min} and #{@model.max} minutes"
        label: 'Runtime'

    else if @model.type == 'search'
      x =
        value: _.escape "Titles containing “#{@model.term}”"
        label: 'Search'

    else if @model.comparison? && @model.value instanceof Date
      date = @model.value
      x =
        preposition: 'on'
        value: [
            date.getDate()
            DvdLibrary.Helpers.months[date.getMonth()].substr(0, 3)
            date.getFullYear()
          ].join ' '

    else if @model.comparison?
      x =
        preposition: 'in'

    else if @model.type == 'filter'
      x =
        value: DvdLibrary.Models.index[@model.property][@model.value]

    else if @model.type == 'person'
      value = DvdLibrary.Models.index[@model.property][@model.value]
      x =
        label: value.recent_role
        value: value.full_name

    else x = {}

    x.label ||= labels[@model.property] || $.capitalize @model.property
    x.value ||= _.escape @model.value
    x.value = comparisonTemplate x if x.preposition

    @el.innerHTML = template x

    if x.preposition
      @comparison = @$ '.comparison'
      @setPhaseByIndex 2

  focus: (focused) ->
    @$el.toggleClass 'focused', !!focused

  setPhaseByIndex: (index) ->
    index = Math.max 0, Math.min 4, index
    @phase = index
    @model.comparision = phases[@phase].replace /^e/, ''
    $.each phases, (i, phase) => @comparison.toggleClass phase, i == index
    index

  setPhaseByName: (name) ->
    @setPhaseByIndex _.indexOf phases, name

  setPhaseByEvent: (event) ->
    @setPhaseByName event.currentTarget.className

  shiftPhaseByOffset: (offset) -> @setPhaseByIndex @phase + offset
