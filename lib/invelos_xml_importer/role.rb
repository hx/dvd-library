module InvelosXmlImporter
  class Role < Base

    map %w|@Role @CreditSubtype|,  to: :name
    map '@CreditType',             to: :department,   default: 'Cast'

  end
end
