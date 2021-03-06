# == Schema Information
#
# Table name: titles
#
#  id                 :integer          not null, primary key
#  barcode            :string(255)
#  title              :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  overview           :text
#  sort_title         :string(255)
#  production_year    :integer
#  release_date       :date
#  runtime            :integer
#  certification      :string(255)
#  library_id         :integer
#  parent_id          :integer
#  vendor_id          :string(255)
#  third_party_poster :string(255)
#

class Title < ActiveRecord::Base

  extend FindByScopeSet

  acts_as_tree

  xml_importer do
    map :ID,              to: :vendor_id,       key: true
    map :UPC,             to: :barcode,         value: lambda { |element| element.content.gsub(/\D+/, '') }
    map :Title,           to: :title
    map :SortTitle,       to: :sort_title
    map :Overview,        to: :overview
    map :ProductionYear,  to: :production_year
    map :Released,        to: :release_date
    map :RunningTime,     to: :runtime
    map :Rating,          to: :certification
    map 'Actors/Actor',   to: :roles
    map 'Credits/Credit', to: :roles
    map 'Studios/Studio', to: :studio_involvements
    map 'Genres/Genre',   to: :title_genres
    map 'MediaTypes/*[text()="true"]',  to: :title_media_types
    map 'BoxSet/Parent',                to: :parent
    map 'BoxSet/Contents/Content',      to: :children
  end

  attr_accessible :barcode,
                  :title,
                  :sort_title,
                  :overview,
                  :production_year,
                  :release_date,
                  :runtime,
                  :certification,
                  :vendor_id

  serialize :third_party_poster, Hash

  def self.all_certifications
    @all_certifications ||=
      select(:certification)
      .group(:certification)
      .map(&:certification)
      .select(&:present?)
  end

  belongs_to :library

  has_many :roles, include: :person, dependent: :delete_all
  has_many :people, through: :roles

  has_many :studio_involvements, include: :studio, dependent: :delete_all
  has_many :studios, through: :studio_involvements

  has_many :title_media_types, include: :media_type, dependent: :delete_all
  has_many :media_types, through: :title_media_types

  has_many :title_genres, include: :genre, dependent: :delete_all
  has_many :genres, through: :title_genres

  TV_PATTERN = /(st|nd|rd|th|complete|final) (Seasons?|Series)|(Seasons?|Series|Volumes?) (\d|one|two|three|four|five|six|seven|eight|nine|ten|eleven|twelve|[a-z]+teen|twenty)/i

  def tv?
    @is_tv ||= !!title.match(TV_PATTERN) || genres.tv.any?
  end

  def poster
    @poster ||= Poster.new self
  end

  def poster=(image)
      File.open(poster.expected_path, 'wb') { |f| f.write image.read } if image.respond_to? :read
  end

end
