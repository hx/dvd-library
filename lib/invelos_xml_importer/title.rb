module InvelosXmlImporter
  class Title < Base

    map :UPC,   to: :barcode, key: true, filter: lambda { |upc| upc.gsub(/\D+/, '') }
    map :Title, to: :title

  end
end
