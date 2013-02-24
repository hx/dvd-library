# == Schema Information
#
# Table name: libraries
#
#  id           :integer          not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  name         :string(255)      default("")
#  tmdb_api_key :string(255)
#  tvdb_api_key :string(255)
#

class Library < ActiveRecord::Base

  attr_accessible :name

  after_initialize { |library| library.name ||= 'New Library' }

  has_many :titles

end
