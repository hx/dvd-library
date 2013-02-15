class LibrariesController < ApplicationController

  include LibrariesHelper

  def index
    #todo A libraries index
    render text: 'Libraries. Yeah.', layout: true
  end

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
          #scopes: 'search/Whatever you typed/sort/genre/rsort/title/production-year/2013/release-date/2013-01-01/genre/1/media-type/2/person/4',
          #people: {
          #  4 => {
          #    full_name: 'Sean Connery',
          #    recent_role: 'Actor, The League of Extraordinary Gentlemen'
          #  }
          #}
          scopes: scopes.to_s,
          people: people
        }.to_json
      end
    end
  end
end
