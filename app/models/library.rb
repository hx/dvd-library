# == Schema Information
#
# Table name: libraries
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Library < ActiveRecord::Base

  has_many :titles

end
