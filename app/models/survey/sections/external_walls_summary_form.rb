module Survey
  module Sections
    class ExternalWallsSummaryForm < BaseForm
      def materials
        []
      end

      def relevant?
        record.has_residential_use != false
      end
    end
  end
end
