module 'Title Scopes'

valid_paths = [
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

valid_path_combinations = (exponent) ->
  ret = valid_paths.slice 0
  while exponent-- > 0
    previous = ret
    ret = []
    for p1 in valid_paths
      for p2 in previous
        ret.push p1 + '/' + p2
  ret

x = 0

for i in [1..2]
  test "Path parsing and building - sets of #{i}", ->
    $.each valid_path_combinations(x++), (index, path) ->
      scope = new DvdLibrary.TitleScopeSet path
      equal scope.toString(), path, "'#{path}' should be a vaild scope"
      equal scope.scopes.length, x, "... and should have #{x} scope(s)"
