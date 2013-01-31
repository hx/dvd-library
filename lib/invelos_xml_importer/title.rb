module InvelosXmlImporter

  class Title < Base

    map(:UPC,   to: :barcode) { |upc| upc.gsub(/\D+/, '') }
    map(:Title, to: :title  )

  end

end