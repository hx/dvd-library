module ApplicationHelper
  def person_index_for(scope_set)
    index = {}
    scope_set.by_type(:person).each do |scope|
      person = Person.find scope.value.to_i
      index[person.id] = {
          full_name: person.full_name,
          recent_work: person.recent_work
      }
    end
    index
  end
end
