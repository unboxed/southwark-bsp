module Survey
  module Sections
    class UprnForm < BaseForm
      UPRN_FORMAT = /\A\d{10,12}\z/.freeze

      attribute :uprn, :string
      validates :uprn, presence: true, format: { with: UPRN_FORMAT, allow_blank: true }

      validate if: :uprn_valid? do
        errors.add :uprn, :not_found unless record.building
      end

      before_validation do
        if uprn_valid?
          record.building = Building.find_by(uprn: uprn)
        end
      end

      def next_stage
        completed ? "check_your_answers" : "ownership"
      end

      def uprn_valid?
        uprn.present? && UPRN_FORMAT.match?(uprn)
      end
    end
  end
end
