# == Schema Information
#
# Table name: people
#
#  id          :integer          not null, primary key
#  first_name  :string(255)
#  middle_name :string(255)
#  last_name   :string(255)
#  birth_year  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Person < ActiveRecord::Base
  include InvelosXmlImporting

  attr_accessible :birth_year, :first_name, :last_name, :middle_name

  has_many :roles, include: :title
  has_many :titles, through: :roles

end
