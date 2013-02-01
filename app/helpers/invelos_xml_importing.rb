module InvelosXmlImporting

  module ClassMethods

    def from_xml(source)
      @@importer_class ||= InvelosXmlImporter.const_get self.to_s
      @@importer_class.import source
    end

    def type_of_column(column)
      columns_hash[column.to_s].type
    end

  end

  def self.included(base)
    base.extend ClassMethods
  end

end