class Title < ActiveRecord::Base

  attr_accessible :barcode, :title

  belongs_to :library

end
