require 'fileutils'
require "#{Rails.root}/lib/tasks/_helpers"

namespace :library do
  namespace :posters do

    desc 'Import posters from DVD Profiler'

    task import: :environment do

      source = File.expand_path(ENV['path'] || '.')

      Title.all.each do |title|
        unless title.poster.exists?
          source_file = File.join source, title.vendor_id + 'f.jpg'
          if File.exists? source_file
            puts "Importing #{source_file}..."
            FileUtils.copy source_file, title.poster.expected_path
          else
            puts "Attempting download of poster for #{title.title} (#{title.production_year})..."
            title.poster.download true
            Thread.pass
          end
        end

      end

      puts 'Waiting for posters to finish downloading...'
      Poster.wait_for_downloads

    end

  end
end