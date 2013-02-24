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
      tpp = ThirdPartyPoster.new @title
      @title.update_attribute :third_party_poster, {url: tpp.url, size: tpp.size} if tpp.url
    end
    @third_party = @title.third_party_poster
  end

end
