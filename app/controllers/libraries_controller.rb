class LibrariesController < ApplicationController
  def index
    #todo A libraries index
    render text: 'Libraries. Yeah.', layout: true
  end

  def search
    respond_to do |format|
      format.json do
        render text: {
          scopes: 'search/Whatever you typed/production-year/2013/release-date/2013-01-01/genre/1/media-type/2/person/4',
          people: {
            4 => {
              first_name: 'Sean',
              last_name: 'Connery',
              recent_work: 'The League of Extraordinary Gentlemen'
            }
          }
        }.to_json
      end
    end
  end
end
