module Survey
  module Sections
    class ExternalWallsSummaryForm < BaseForm
      def materials
        []
      end

      def next_stage
        completed ? "check_your_answers_form" : "external_wall_structures"
      end
    end
  end
end
