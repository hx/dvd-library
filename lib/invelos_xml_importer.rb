module InvelosXmlImporter
  class Base

    class << self

      def map(xml_element, options)
        (@maps ||= {})[xml_element] = options
      end

      def import(source)
        setup_reflections
        source = Nokogiri::XML(source) unless source.respond_to? :xpath
        attributes = {}
        @maps.each do |xml_element, options|
          matches = source/xml_element
          if matches.any?
            content = matches.first.content
            content = options[:filter].call(content) if options[:filter]
            attributes[options[:to] || xml_element] = content
          end
        end
        @model_class.where(attributes.select { |k, i| @model_keys.include? k } ).first_or_initialize attributes
      end

      private

        def setup_reflections
          @model_class ||= Kernel.const_get to_s[/\w+$/]
          @model_keys  ||= @maps.select { |k, i| i[:key] }.map { |k, i| i[:to] }
        end

    end

  end
end