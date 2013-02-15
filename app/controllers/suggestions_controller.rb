class SuggestionsController < ApplicationController

  include SuggestionsHelper

  def search
    respond_to do |format|
      format.json do
        scopes = search_suggestions(params[:query] || '')
        people = {}
        scopes.by_type(:person).each do |scope|
          person = Person.find scope.value.to_i
          people[person.id] = {
              full_name: person.full_name,
              recent_work: person.recent_work
          }
        end
        render text: {
            scopes: scopes.to_s,
            people: people
        }.to_json
      end
    end
  end
end
