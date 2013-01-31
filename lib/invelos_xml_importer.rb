module InvelosXmlImporter

  class Base

    class << self

      def map(xml_element, options, &block)
        (@@maps ||= {})[xml_element] = { options: options, filter: block }
      end

      def import(source)
        source = Nokogiri::XML(source) unless source.respond_to? :xpath
        @@model_class ||= Kernel.const_get to_s[/\w+$/]
        attributes = {}
        @@maps.each do |xml_element, mapping|
          matches = source/xml_element
          if matches.any?
            content = matches.first.content
            content = mapping[:filter].call(content) if mapping[:filter]
            attributes[mapping[:options][:to] || xml_element] = content
          end
        end
        @@model_class.new attributes
      end

    end

  end

end