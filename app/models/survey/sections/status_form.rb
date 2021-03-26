module Survey
  module Sections
    class StatusForm < BaseForm
      STATUSES = %w[existing demolished]

      attribute :status, :string
      validates :status, inclusion: { in: STATUSES }

      attribute :status_details, :string
      validates :status_details, length: { maximum: 2000 }

      def statuses
        STATUSES
      end
    end
  end
end
