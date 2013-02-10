class TitlesController < ApplicationController

  def index
    library = Library.find_by_id(params[:library_id])
    respond_to do |format|
      format.html do
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
        @title = library.titles.find_by_id params[:id]
      end
    end
  end

end
