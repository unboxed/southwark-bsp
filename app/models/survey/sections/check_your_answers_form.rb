module Survey
  module Sections
    class CheckYourAnswersForm < BaseForm
      SUMMARIES = %w[
        ownership
        building
        management
        features
      ].freeze

      before_save do
        record.completed_at = Time.current
      end

      def summaries(template)
        filtered_summaries.map do |name|
          summary(template, name)
        end
      end

      def next_stage
        "complete"
      end

      private

      def summary(template, name)
        summary_class(name).new(name, template, record)
      rescue NameError
        raise SummaryNotFound, "Couldn't find summary class for '#{name}'"
      end

      def summary_class(name)
        "Survey::Summaries::#{name.camelize}Summary".constantize
      end

      def filtered_summaries
        SUMMARIES.select do |name|
          unless record.has_residential_use
            next false unless name.in?(%w[ownership building])
          end

          true
        end
      end
    end
  end
end
