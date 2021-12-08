module Survey
  module Summaries
    class BaseSummary
      class_attribute :attribute_names, default: []

      attr_reader :name, :template, :record

      delegate :building, to: :record
      delegate :t, :goto_path, to: :template
      delegate :simple_format, to: :template
      delegate :number_with_precision, to: :template
      delegate :render, to: :template

      def initialize(name, template, record)
        @name = name
        @template = template
        @record = record
      end

      def heading
        t(name, scope: :"survey.summary.heading", default: name.humanize)
      end

      def attributes(&block)
        attribute_names.each do |attribute|
          block.call(name_for(attribute), value_for(attribute), url_for(attribute))
        end
      end

      def to_partial_path
        "surveys/summary"
      end

      private

      def name_for(attribute)
        t(attribute, scope: :"survey.summary.attributes.#{name}", default: attribute.to_s.humanize)
      end

      def value_for(attribute)
        public_send(:"value_for_#{attribute}")
      end

      def url_for(attribute)
        public_send(:"url_for_#{attribute}")
      end

      def lookup(key, scope, extra = {})
        options = {
          scope: :"survey.summary.values.#{name}.#{scope}",
          default: key.to_s.humanize
        }.merge(extra)

        t(key, options)
      end
    end
  end
end
