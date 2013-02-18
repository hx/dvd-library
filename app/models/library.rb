# == Schema Information
#
# Table name: libraries
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  name       :string(255)      default("")
#

class Library < ActiveRecord::Base

  attr_accessible :name

  has_many :titles

end
