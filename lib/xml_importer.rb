module XmlImporter

  @importers = {}

  def self.setup(klass, &block)
    @importers[klass] ||= Importer.new(klass, block)
    def klass.from_xml *args
      XmlImporter.import self, *args
    end
  end

  def self.import(klass, *args)
    @importers[klass].import *args
  end

end