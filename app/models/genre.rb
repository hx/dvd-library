# == Schema Information
#
# Table name: genres
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Genre < ActiveRecord::Base

  xml_importer { map '.', to: :name, key: true }

  attr_accessible :name

  has_many :title_genres, include: :title, dependent: :delete_all
  has_many :titles, through: :title_genres

end
