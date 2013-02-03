module InvelosXmlImporter
  class Title < Base

    map :UPC,             to: :barcode,         key: true, filter: lambda { |upc| upc.gsub(/\D+/, '') }
    map :Title,           to: :title
    map :SortTitle,       to: :sort_title
    map :Overview,        to: :overview
    map :ProductionYear,  to: :production_year
    map :Released,        to: :release_date
    map :RunningTime,     to: :runtime
    map :Rating,          to: :certification
    map 'Actors/Actor',   to: :roles
    map 'Credits/Credit', to: :roles

  end
end
