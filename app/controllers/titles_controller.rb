class TitlesController < ApplicationController

  before_filter :find_library
  before_filter :validate_scope, only: :index

  def index
    respond_to do |format|
      format.html do
        @models = {
            person: person_index_for(@scope)
        }
        [MediaType, Genre, Studio].each do |klass|
          @models[klass.name.underscore.gsub('_', '-').to_sym] = Hash[klass.all.map do |record|
            [record.id, record.name]
          end]
        end
        @titles = Hash[@library.titles.map { |t| [t.id, t.title] }]
      end
      format.json do
        title_ids = @library.titles.find_by_scope_set(@scope).map(&:id)
        render text: title_ids.to_json
      end
    end
  end

  def show
    respond_to do |format|
      format.json do
        title = @library.titles.find_by_id params[:id]
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

  private

    def find_library
      @library = Library.find params[:library_id]
    end

    def validate_scope
      @scope = TitleScopeSet.new params[:scope]
      unless params[:scope].blank? or URI.decode(@scope.to_s) == params[:scope]
        redirect_to "/libraries/#{@library.id}/titles/#{@scope}"
      end
    end

end
