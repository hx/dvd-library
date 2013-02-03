module InvelosXmlImporter
  class Base

    class << self

      def map(xpaths, options)
        type = associations.include?(options[:to]) ? :group : :flat
        maps(type)[xpaths] = options
      end

      def import(source, attributes = {})
        source = Nokogiri::XML(source).children[0] unless source.respond_to? :xpath
        associations.select do |name, association|
          association.macro == :belongs_to &&
              attributes.keys.exclude?(association.foreign_key) &&
              association.klass.respond_to?(:from_xml)
        end.each do |name, association|
          attributes[association.foreign_key] = association.klass.from_xml source
        end
        process_maps(:flat, source) do |element, options|
          content = element.content
          content = options[:filter].call(content) if options[:filter]
          attributes[options[:to] || element.name] = content
        end
        model = if model_keys.any?
          model_class.where(attributes.select { |k| model_keys.include?(k) } ).first_or_create attributes
        else
          model_class.where(attributes).first_or_create
        end
        process_maps(:group, source) do |element, options|
          association = associations[options[:to] || element.name]
          group_class = association.klass
          group_attributes = {association.foreign_key.to_sym => model}
          group_class.from_xml element, group_attributes
        end
        model
      end

      private

        def process_maps(type, xml_source)
          maps(type).each do |xpaths, options|
            xpaths = [xpaths] unless xpaths.respond_to? :each
            matches = xml_source.xpath *xpaths.map(&:to_s)
            if matches.any?
              matches.each { |m| yield m, options }
            elsif options[:default]
              yield(MockXmlElement.new(name: xpaths[0], content: options[:default]), options)
            end
          end
        end

        def model_class_name
          @model_class_name ||= name[/\w+$/]
        end

        def model_class
          @model_class ||= Kernel.const_get model_class_name
        end

        def associations
          @associations ||= model_class.reflections
        end

        def maps(type)
          (@maps ||= {})[type] ||= {}
        end

        def model_keys
          @model_keys ||= maps(:flat).select { |k, i| i[:key] }.map { |k, i| i[:to] }
        end

    end

  end

  private

    class MockXmlElement
      def initialize(values)
        @values = values
      end

      def method_missing(key)
        @values[key]
      end
    end
end