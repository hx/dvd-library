module XmlImporter
  module ActiveRecordExtension

    extend ActiveSupport::Concern

    module ClassMethods
      def xml_importer(&block)
        XmlImporter::setup self, &block
      end
    end

  end

  ActiveRecord::Base.send :include, ActiveRecordExtension
end