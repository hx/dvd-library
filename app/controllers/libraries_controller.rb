class LibrariesController < ApplicationController
  def show
    @library = Library.find_by_id params[:id]
    @titles = @library.titles.map(&:title)
    #render text: 'One moment...', layout: :default
  end
end
