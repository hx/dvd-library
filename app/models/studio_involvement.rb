# == Schema Information
#
# Table name: studio_involvements
#
#  id         :integer          not null, primary key
#  studio_id  :integer
#  title_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class StudioInvolvement < ActiveRecord::Base

  InvelosXmlImporter.setup(self)
  
  attr_accessible :studio_id, :title_id
  belongs_to :title
  belongs_to :studio
end
