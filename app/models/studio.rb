# == Schema Information
#
# Table name: studios
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Studio < ActiveRecord::Base
  include InvelosXmlImporting

  attr_accessible :name
  has_many :studio_involvements, include: :title, dependent: :delete_all
  has_many :titles, through: :studio_involvements
end
