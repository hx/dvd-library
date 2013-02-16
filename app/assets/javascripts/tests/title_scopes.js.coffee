module 'Title Scopes'

TitleScopeSet = DvdLibrary.TitleScopeSet

testScopes = [
  'search/foo/sort/genre/rsort/title/person/2/studio/1/media-type/3/release-date-lt/2002-01-01'
]

validScopes = [
  'search/anything/you/like'
  'sort/title'
  'rsort/production-year'
  'runtime/90-125'
  'certification/MA 15+'
  'person/14'
  'studio/1'
  'production-year/2000'
  'production-year-lte/1984'
  'production-year-gt/1999'
  'release-date/2012-02-12'
  'release-date-lt/2012-02-12'
  'release-date-gte/2012-02-12'
]

test 'Basic parsing', ->
  expect validScopes.length
  for scope in validScopes
    equal (new TitleScopeSet scope).toString(), scope, "#{scope} should be a valid scope"

test 'Parsing multiple scopes', ->
  for first in validScopes
    for second in validScopes
      if first != second
        scope = first + '/' + second
        equal (new TitleScopeSet scope).toString(), scope, "#{scope} should be a valid scope"

test 'Division of scopes by type', ->
  scopes = new TitleScopeSet testScopes[0]
  equal scopes.byType('search').length, 1, 'There should be 1 search scope'
  equal scopes.byType('sort').length,   2, 'There should be 2 sort scopes'
  equal scopes.byType('person').length, 1, 'There should be 2 person scope'
  equal scopes.byType('filter').length, 3, 'There should be 3 filter scopes'

test 'Cloning', ->
  scopes = new TitleScopeSet testScopes[0]
  equal scopes.clone().toString(), scopes.toString(), 'Original and clone should have the same string representation'

test 'Augmentation', ->
  scopes = new TitleScopeSet 'search/foo'
  scopes.augment 'sort/title'
  equal scopes.toString(), 'search/foo/sort/title', 'New scope string should augment existing scope'
  scopes.augment (new DvdLibrary.TitleScopeSet 'genre/12').scopes[0]
  equal scopes.toString(), 'search/foo/sort/title/genre/12', 'New scope should augment existing scope'
  scopes.augment new DvdLibrary.TitleScopeSet 'studio/69'
  equal scopes.toString(), 'search/foo/sort/title/genre/12/studio/69', 'New scope set should augment existing scope'

test 'Selective Augmentation', ->
  scope = new TitleScopeSet 'search/foo'
  scope.augment 'search/bar'
  equal scope.toString(), 'search/bar', 'New search should replace old search'

  scope = new TitleScopeSet 'sort/title'
  scope.augment 'rsort/title'
  equal scope.toString(), 'rsort/title', 'New sort should replace old sort on same column'

  scope = new TitleScopeSet 'person/5'
  scope.augment 'person/5'
  equal scope.toString(), 'person/5', 'Only add unique scopes'