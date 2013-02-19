require 'open-uri'

class Poster

  STORE = File.join Rails.root, 'public/posters'
  URI = '/posters/%s'

  def log(*args)
    Rails.logger.debug *args
  end

  class << self

    def log(*args)
      Rails.logger.debug *args
    end

    def queue_for_download(poster)
      (@queue ||= []) << poster
      process_queue
    end

    def wait_for_downloads
      @download_thread.join if @download_thread
    end

    private

      def process_queue
        return if @queue.empty?
        if Thread.current != @download_thread
          return @download_thread ||= Thread.new { process_queue }
        end
        while @queue.any?
          @queue.shift.download
        end
        @download_thread = nil
      end

  end

  attr_reader :title

  def initialize(title)
    @title = title
    unless exists?
      title.children.each do |child|
        if child.poster.exists?
          @file_name = child.poster.file_name
          return
        end
      end
    end
  end

  def path
    expected_path if exists?
  end

  def exists?
    File.exists? expected_path
  end

  def dimensions
    if exists?
      @size ||= FastImage.size(path)
    else
      third_party[:size]
    end
  end

  def uri
    if exists?
      @uri ||= URI % file_name
    else
      third_party[:url]
    end
  end

  def download(async = false)
    return Poster.queue_for_download self if async
    return if exists?
    return unless third_party[:url]
    data = open(third_party[:url]).read rescue return
    if data.length > 1000
      File.open(expected_path, 'wb') { |file| file.write data }
    else
      0
    end
  end

  def expected_path
    File.join STORE, file_name
  end

  def file_name
    @file_name ||= title.vendor_id + '.jpg'
  end

  def third_party
    return @third_party unless @third_party.nil?
    if @title.third_party_poster[:url].nil?
      if title.tv?
        #todo something for the tv shows
      elsif @title.library.tmdb_api_key
        Tmdb.api_key = @title.library.tmdb_api_key
        Tmdb.default_language = 'en'
        movie_titles = [title.title]
        movie_titles.unshift "#{title.title} (#{title.production_year})" if title.production_year > 0
        movie_titles << title.title.gsub(/&/, ' and ').gsub(/[^\w]+/, ' ')
        movie_titles << title.title.gsub(/\s*[-:\/(].*/, ' ')
        movie_titles.uniq.each do |movie_title|
          movie_data = TmdbMovie.find title: movie_title, limit: 1, expand_results: false
          if movie_data.respond_to? :poster
            url = movie_data.poster.sizes.original.url
            size = FastImage.size url, timeout: 5
            @title.update_attribute :third_party_poster, {url: url, size: size}
            break
          end
        end
      end
    end
    @third_party = @title.third_party_poster
  end

end
