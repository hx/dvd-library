class XmlImporter

  @importers = {}
  @@setups = {}

  class << self

    def setup(klass, &block)
      @importers[klass] ||= new klass
      (@@setups[klass] ||= []) << block if block
      def klass.from_xml *args
        XmlImporter.import self, *args
      end
    end

    def import(klass, *args)
      @importers[klass].import *args
    end

  end

  def map(xpaths, options)
    type = associations.include?(options[:to]) ? :group : :flat
    maps(type)[xpaths] = options
  end

  def import(source, attributes = {})
    run_pending_setups
    source = Nokogiri::XML(source).children[0] unless source.respond_to? :xpath
    associations.select do |name, association|
      association.macro == :belongs_to &&
          attributes.keys.exclude?(association.foreign_key) &&
          association.klass.respond_to?(:from_xml)
    end.each do |name, association|
      attributes[association.foreign_key] = association.klass.from_xml source
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

    def initialize(klass)
      @klass = klass
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

    def run_pending_setups
      @@setups[@klass].each { |block| instance_eval &block } if @@setups[@klass]
      @@setups[@klass] = []
    end

    def associations
      @associations ||= @klass.reflections
    end

    def maps(type)
      (@maps ||= {})[type] ||= {}
    end

    def model_keys
      @model_keys ||= maps(:flat).select { |k, i| i[:key] }.map { |k, i| i[:to] }
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