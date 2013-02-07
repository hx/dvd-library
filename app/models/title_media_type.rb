# == Schema Information
#
# Table name: title_media_types
#
#  id            :integer          not null, primary key
#  title_id      :integer
#  media_type_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class TitleMediaType < ActiveRecord::Base

  xml_importer

  attr_accessible :media_type_id, :title_id

  belongs_to :title
  belongs_to :media_type

end
