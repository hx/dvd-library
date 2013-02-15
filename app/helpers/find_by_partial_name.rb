module FindByPartialName

  def find_by_partial_name(term, limit = nil, column_name = :name)
    column  = arel_table[column_name]
    scope   =  order(column_name)
    matches =  scope.where(column.matches   "#{term}%").limit(limit).all # so we don't have pointless count() queries
    matches += scope.where(column.matches "_%#{term}%").limit(limit - matches.size) if limit && matches.size < limit
    matches.uniq
  end

end