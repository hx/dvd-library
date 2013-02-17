template = _.template """
  <div class="label">
    <span class="text"><%- label %></span>
  </div>
  <div class="value">
    <span class="text"><%- value %></span>
    <a href="javascript:" class="remove">×</a>
  </div>
"""

labels =
  'media-type':       'Media'
  'production-year':  'Produced'

DvdLibrary.Views.ScopeTokenView = ScopeTokenView = Backbone.View.extend

  tagName: 'div'

  className: 'token'

  events:
    'click a.remove': 'remove'

  initialize: ->
    index = DvdLibrary.Models.index[@model.property]

    if @model.type == 'sort'
      x =
        value: $.capitalize @model.criteria
        label: 'Sort by ' + (if @model.reverse then '◀' else '▶')

    else if @model.property == 'runtime'
      x =
        value: "#{@model.min}–#{@model.max}min"
        label: 'Runtime'

    else if @model.type == 'search'
      x =
        value: @model.term
        label: 'Contains'

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
        value: if index then index[@model.value] else @model.value

    else if @model.type == 'person'
      person = index[@model.value]
      x =
        label: 'Cast/Crew'
        value: person.full_name

    else x = {}

    x.label ||= labels[@model.property] || $.capitalize @model.property
    x.value ||= @model.value

    if x.preposition
      comparison = @model.comparison || ''
      value = []
      value.push x.preposition if !comparison || comparison[2] == 'e'
      value.push 'or'          if comparison[2] == 'e'
      value.push 'before'      if comparison[0] == 'l'
      value.push 'after'       if comparison[0] == 'g'
      value.push x.value
      x.value = value.join(' ').replace(/^\w/, (x) -> x.toUpperCase())

    @el.innerHTML = template x

    @label = @$ '.label'
    @value = @$ '.value'

    @$('.label .text').fitTextHeight .4, @$('.label')
    @$('.value > *').fitTextHeight .55, @$('.value')

  labelWidth: -> @label[0].offsetWidth
  valueWidth: -> @value[0].offsetWidth

  remove: -> @trigger 'remove', @model
