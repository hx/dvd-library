class ThirdPartyPoster

  def initialize(title)
    @title = title
  end

  def url
    @url ||= @title.tv? && from_thetvdb || from_themoviedb
  end

  def size
    @size ||= FastImage.size(url || '', timeout: 5)
  end

  private

    def tv_show
      @tv_show ||= NameAndSeason.new @title.title
    end

    def tvdb
      #noinspection RubyClassVariableUsageInspection
      @@tvdb ||= (key = @title.library.tvdb_api_key) && TvdbParty::Search.new(key)
    end

    def from_thetvdb
      return unless tvdb
      url = nil
      tvdb.search(tv_show.name).each do |result|
        url ||= poster_for_series_id(result['seriesid'])
      end
      url
    end

    def poster_for_series_id(series_id)
      series = tvdb.get_series_by_id(series_id)
      posters = tv_show.season ? series.season_posters(tv_show.season, 'en') : []
      posters = series.posters('en') if posters.empty?
      posters.any? && posters.first.url
    end

    def from_themoviedb
      return unless (@tmdb_key ||= @title.library.tmdb_api_key)
      Tmdb.api_key = @tmdb_key
      Tmdb.default_language = 'en'
      movie_titles = [@title.title]
      movie_titles.unshift "#{@title.title} (#{@title.production_year})" if @title.production_year > 0
      movie_titles << @title.title.gsub(/&/, ' and ').gsub(/[^\w]+/, ' ')
      movie_titles << @title.title.gsub(%r|\s*[-:/(].*|, ' ')
      movie_titles << @title.title.sub(/.*'s\s+/, '')
      movie_titles.uniq.each do |movie_title|
        movie_data = TmdbMovie.find title: movie_title, limit: 1, expand_results: false
        return movie_data.poster.sizes.original.url if movie_data.respond_to? :poster
      end
      nil
    end

end