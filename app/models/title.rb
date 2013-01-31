class Title < ActiveRecord::Base
  include InvelosXmlImporting

  attr_accessible :barcode, :title

  belongs_to :library

end
