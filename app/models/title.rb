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
#

class Title < ActiveRecord::Base
  include InvelosXmlImporting

  attr_accessible :barcode,
                  :title,
                  :sort_title,
                  :overview,
                  :production_year,
                  :release_date,
                  :runtime,
                  :certification

  belongs_to :library
  has_many :roles, include: :person, dependent: :delete_all
  has_many :people, through: :roles
  has_many :studio_involvements, include: :studio, dependent: :delete_all
  has_many :studios, through: :studio_involvements

end
