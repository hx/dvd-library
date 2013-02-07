module XmlImporter
  class Importer

    def map(xpaths, options)
      type = associations.include?(options[:to]) ? :group : :flat
      maps(type)[xpaths] = options
    end

    def import(source, attributes = {})
      run_pending_setup
      source = Nokogiri::XML(source).root unless source.respond_to? :xpath
      associations.select do |name, association|
        association.macro == :belongs_to &&
            attributes.keys.exclude?(association.foreign_key.to_sym) &&
            association.klass.respond_to?(:from_xml) &&
            name != :parent
      end.each_value do |association|
        attributes[association.foreign_key.to_sym] = association.klass.from_xml source
      end
      process_maps(:flat, source) do |element, options|
        attributes[options[:to] || element.name] = options[:value] ? options[:value].call(element) : element.content
      end
      model = if model_keys.any?
                @klass.where(attributes.select { |k| model_keys.include?(k) } ).first_or_create attributes
              else
                @klass.where(attributes).first_or_create
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

      def initialize(klass, block)
        @klass = klass
        @setup = block
      end

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

      def run_pending_setup
        instance_eval &@setup if @setup
        @setup = nil
      end

      def associations
        @associations ||= @klass.reflections
      end

      def maps(type)
        (@maps ||= {})[type] ||= {}
      end

      def model_keys
        @model_keys ||= maps(:flat).values.select { |i| i[:key] }.map { |i| i[:to] }
      end

      class MockXmlElement
        def initialize(values)
          @values = values
        end

        def method_missing(key)
          @values[key]
        end
      end
  end
end