namespace :library do

  desc 'Clear the library'
  task clear: :environment do
    Library.destroy_all
  end

  desc 'Import XML files exported from DVD Profiler'
  task import: :environment do
    puts "Running in #{Rails.env} environment"
    path = File.expand_path(ENV['path'] || '.')
    library = Library.first_or_create
    puts "Scanning #{File.join path, '*.xml'}..."
    files = Dir[File.join path, '*.xml']
    start_time = Time.now
    last_length = 0
    file_count = files.size
    logger = ActiveRecord::Base.logger
    puts 'Disabling ActiveRecord logging...'
    old_logger_level = logger.level
    ActiveRecord::Base.logger.level = Logger::Severity::UNKNOWN
    files.each_with_index do |file, index|
      columns = `stty size`[/\d+$/].to_i
      elapsed = Time.now - start_time
      remaining = if index > 0
        (elapsed / index) * (file_count - index)
      else
        0
      end.divmod 60
      elapsed = elapsed.divmod 60
      message = " - %02d:%02d so far | %02d:%02d to go | %s/%s | Importing %s..." % [
        elapsed[0],
        elapsed[1],
        remaining[0],
        remaining[1],
        (index + 1).to_s.rjust(file_count.to_s.length),
        file_count,
        file
      ]
      message = message[0...columns] if message.length > columns
      this_length = message.length
      message = message.ljust last_length if message.length < last_length
      last_length = this_length
      print "\x1b[A" if index > 0
      puts message.gsub(/(\d\d:\d\d)/, "\x1b[1m\\1\x1b[0m")
      File.open(file, 'r') do |io|
        library.titles.from_xml io
      end
    end
    puts 'Restoring ActiveRecord logging...'
    logger.level = old_logger_level
    puts 'Done.'
  end
end