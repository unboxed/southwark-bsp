module Survey
  module Sections
    class ExternalWallsSummaryForm < BaseForm
      validates :materials, presence: true

      def materials
        []
      end
    end
  end
end
