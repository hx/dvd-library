module XmlImporter
  class Importer

    def map(xpaths, options)
      association = associations[options[:to]]
      type = association ? association.macro : :flat
      maps(type)[xpaths] = options
    end

    def import(source, attributes = {})
      run_pending_setup
      source = Nokogiri::XML(source).root unless source.respond_to? :xpath
      associations.values.select do |association|
        association.macro == :belongs_to &&
            attributes.keys.exclude?(association.foreign_key.to_sym) &&
            association.klass.respond_to?(:from_xml) &&
            association.klass != @klass
      end.each do |association|
        attributes[association.foreign_key.to_sym] = association.klass.from_xml source
      end
      process_maps(:flat, source) do |element, options|
        attributes[options[:to] || element.name] = options[:value] ? options[:value].call(element) : element.content
      end
      process_maps(:belongs_to, source) do |element, options|
        key = model_keys[0]
        value = element.content
        unless value.empty?
          owner = @klass.where(key => value).first
          attributes[options[:to] || element.name] = owner if owner
        end
      end
      model = if model_keys.any?
                @klass.where(attributes.select { |k| model_keys.include?(k) } ).first_or_create attributes
              else
                @klass.where(attributes).first_or_create
              end
      process_maps(:has_many, source) do |element, options|
        association = associations[options[:to] || element.name]
        group_class = association.klass
        if group_class == @klass
          key = model_keys[0]
          value = element.content
          unless value.empty?
            child = @klass.where(key => value).first
            if child
              foreign_key = association.foreign_key.to_sym
              child.update_attribute foreign_key, model.id
            end
          end
        else
          group_attributes = {association.foreign_key.to_sym => model}
          group_class.from_xml element, group_attributes
        end
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