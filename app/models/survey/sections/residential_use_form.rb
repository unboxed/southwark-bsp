module Survey
  module Sections
    class ResidentialUseForm < BaseForm
      USES = %w[social_housing private_housing student_accommodation hotel].freeze

      attribute :usage, :string
      validates :usage, inclusion: { in: USES }

      def residential_use_options
        USES
      end

      def next_stage
        completed ? "check_your_answers" : "building_management"
      end
    end
  end
end
