class TitlesController < ApplicationController

  before_filter :find_library
  before_filter :validate_scope, only: :index

  def index
    respond_to do |format|
      format.html do
        @models = {
            person: person_index_for(@scope),
            library: { @library.id => @library.name },
            title: Hash[@library.titles.map { |t| [t.id, t.title] }]
        }
        [MediaType, Genre, Studio].each do |klass|
          @models[klass.name.underscore.gsub('_', '-').to_sym] = Hash[klass.all.map do |record|
            [record.id, record.name]
          end]
        end
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

  def create
    respond_to do |format|
      format.json do
        file = params[:files] && params[:files].first.last
        resp = { errors: [] }
        if file.nil?
          resp[:errors].push code: 1, message: 'No files.'
        elsif file.content_type == 'text/xml'
          begin
            title = @library.titles.from_xml file.tempfile
          rescue
            resp[:errors].push code: 3, message: 'Invalid XML format.'
          else
            if title.vendor_id.present?
              resp[:title] = {
                  title: title.title
              }
            else
              resp[:errors].push code: 4, message: 'Unrecognised XML format.'
            end
          end
        elsif file.content_type == 'image/jpeg'
          vendor_id = /^(.+)f\.jpg$/.match file.original_filename
          if vendor_id.nil?
            resp[:errors].push code: 5, message: 'Invalid file name.'
          else
            title = @library.titles.find_by_vendor_id vendor_id[1]
            if title.nil?
              resp[:errors].push code: 6, message: 'Title not found.'
            else
              title.poster = file.tempfile
              resp[:title] = {
                  title: title.title
              }
            end
          end
        else
          resp[:errors].push code: 2, message: 'I can\'t do anything with this type of file.'
        end
        render text: resp.to_json
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
