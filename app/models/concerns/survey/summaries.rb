module Survey
  module Summaries
    extend ActiveSupport::Concern

    SUMMARIES = %w[
      ownership
      building
      management
      features
    ].freeze

    included do
      def summaries(template)
        filtered_summaries.map do |name|
          summary(template, name)
        end
      end

      def summary(template, name)
        summary_class(name).constantize.new(name, template, self)
      rescue NameError
        raise SummaryNotFound, "Couldn't find summary class for '#{name}'"
      end

      def summary_class(name)
        "Survey::Summaries::#{name.camelize}Summary"
      end

      def filtered_summaries
        SUMMARIES.select do |name|
          unless has_residential_use
            next false unless name.in?(%w[ownership building])
          end

          true
        end
      end
    end
  end
end
