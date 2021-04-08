module Survey
  module Sections
    class CheckYourAnswersForm < BaseForm
      after_assign_record :mark_survey_completed

      private

      def mark_survey_completed
        record.update({ completed: true })
      end
    end
  end
end
