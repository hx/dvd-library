module 'ScopeTokenView'

testData =
  'search/foo':                   [ 'Contains',     'foo'                       ]
  'sort/title':                   [ 'Sort by',      'Title'                     ]
  'rsort/release-date':           [ 'Sort by',      'Release Date'              ]
  'person/1':                     [ 'Cast/Crew',    'Hugh Laurie'               ]
  'genre/1':                      [ 'Genre',        'Action'                    ]
  'media-type/1':                 [ 'Media',        'DVD'                       ]
  'studio/1':                     [ 'Studio',       'Columbia'                  ]
  'release-date/1984-04-29':      [ 'Release Date', 'On 29 Apr 1984'            ]
  'release-date-lt/1984-04-29':   [ 'Release Date', 'Before 29 Apr 1984'        ]
  'release-date-lte/1984-04-29':  [ 'Release Date', 'On or before 29 Apr 1984'  ]
  'release-date-gt/1984-04-29':   [ 'Release Date', 'After 29 Apr 1984'         ]
  'release-date-gte/1984-04-29':  [ 'Release Date', 'On or after 29 Apr 1984'   ]
  'production-year/2007':         [ 'Produced',     'In 2007'                   ]
  'production-year-lt/2007':      [ 'Produced',     'Before 2007'               ]
  'production-year-lte/2007':     [ 'Produced',     'In or before 2007'         ]
  'production-year-gt/2007':      [ 'Produced',     'After 2007'                ]
  'production-year-gte/2007':     [ 'Produced',     'In or after 2007'          ]
  'certification/MA%2015%2B':     [ 'Certification','MA 15+'                    ]

DvdLibrary.Models.index =
  genre:
    1: 'Action'
  'media-type':
    1: 'DVD'
  studio:
    1: 'Columbia'
  person:
    1:
      full_name: 'Hugh Laurie'


test "Correct labels and values", ->
  for i, v of testData
    scope = (new DvdLibrary.TitleScopeSet i).scopes[0]
    view  = new DvdLibrary.Views.ScopeTokenView model: scope
    label = $.trim view.$('.label').text()
    value = $.trim view.$('.value .text').text()
    equal label, v[0], "Scope token for #{i} should have the right label"
    equal value, v[1], "Scope token for #{i} should have the right value"
