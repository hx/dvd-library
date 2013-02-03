# == Schema Information
#
# Table name: title_genres
#
#  id         :integer          not null, primary key
#  title_id   :integer
#  genre_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class TitleGenre < ActiveRecord::Base

  XmlImporter.setup self

  attr_accessible :genre_id, :title_id

  belongs_to :title
  belongs_to :genre

end
