module Survey
  module Sections
    class CheckYourAnswersForm < BaseForm
      before_save do
        record.completed_at = Time.current

        record.building.survey_state.transition_to! :received
      end

      def next_stage
        "complete"
      end
    end
  end
end
