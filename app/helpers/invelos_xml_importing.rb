module InvelosXmlImporting

  module ClassMethods

    def from_xml(*args)
      unless @importer_class
        class_name = self.name.to_sym
        InvelosXmlImporter.const_missing class_name unless InvelosXmlImporter.constants.include? class_name
        @importer_class = InvelosXmlImporter.const_get class_name
      end
      @importer_class.import *args
    end

    def type_of_column(column)
      columns_hash[column.to_s].type
    end

  end

  def self.included(base)
    base.extend ClassMethods
  end

end