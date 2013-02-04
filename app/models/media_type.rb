# == Schema Information
#
# Table name: media_types
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class MediaType < ActiveRecord::Base

  XmlImporter.setup(self) do
    map '.', to: :name, key: true, value: lambda { |element| Rails.logger.debug(element); element.name }
  end

  attr_accessible :name

  has_many :title_media_types, include: :title, dependent: :delete_all
  has_many :titles, through: :title_media_types

end