class LibrariesController < ApplicationController
  def index
    @libraries = Library.all
    @index = {
      library: Hash[@libraries.map { |lib| [lib.id, lib.name] }]
    }
  end
end
