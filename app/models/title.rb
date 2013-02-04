# == Schema Information
#
# Table name: titles
#
#  id              :integer          not null, primary key
#  barcode         :string(255)
#  title           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  overview        :text
#  sort_title      :string(255)
#  production_year :integer
#  release_date    :date
#  runtime         :integer
#  certification   :string(255)
#  library_id      :integer
#

class Title < ActiveRecord::Base

  XmlImporter.setup(self) do
    map :UPC,             to: :barcode,         key: true, value: lambda { |element| element.content.gsub(/\D+/, '') }
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
    map 'MediaTypes/*[text()="true"]',   to: :title_media_types
  end

  attr_accessible :barcode,
                  :title,
                  :sort_title,
                  :overview,
                  :production_year,
                  :release_date,
                  :runtime,
                  :certification

  default_scope order 'sort_title'

  belongs_to :library

  has_many :roles, include: :person, dependent: :delete_all
  has_many :people, through: :roles

  has_many :studio_involvements, include: :studio, dependent: :delete_all
  has_many :studios, through: :studio_involvements

  has_many :title_media_types, include: :media_type, dependent: :delete_all
  has_many :media_types, through: :title_media_types

  has_many :title_genres, include: :genre, dependent: :delete_all
  has_many :genres, through: :title_genres

end
