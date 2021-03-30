module Survey
  module Sections
    class ResidentialUseForm < BaseForm
      USES = %w(social_housing private_housing student_accommodation hotel)

      attribute :usage, type: :string
      validates :usage, inclusion: USES

      def residential_use_options
        USES
      end
    end
  end
end
