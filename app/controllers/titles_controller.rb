class TitlesController < ApplicationController

  def index
    library = Library.find_by_id(params[:library_id])
    respond_to do |format|
      format.html do
        @models = {people: {}}
        [MediaType, Genre, Studio].each do |klass|
          @models[klass.name.underscore.pluralize.to_sym] = Hash[klass.all.map do |record|
            [record.id, record.name]
          end]
        end
        # disregard scope; we're only serving a lookup table of IDs and titles
        @titles = {}
        library.titles.each { |title| @titles[title.id] = title.title }
      end
      format.json do
        #todo Handle params[:scope]
        title_ids = library.titles.map(&:id)
        render text: title_ids.to_json
      end
    end
  end

  def show
    respond_to do |format|
      format.json do
        library = Library.find_by_id params[:library_id]
        title = library.titles.find_by_id params[:id]
        render text: {
          cast:     title.roles.cast.limit(3).map      { |role| role.person.full_name },
          director: title.roles.direction.limit(1).map { |role| role.person.full_name }.join(''),
          poster: {
            size: title.poster.dimensions,
            path: title.poster.uri
          }
        }.to_json
      end
    end
  end

end
