module Survey
  module Sections
    class HasResidentialForm < BaseForm
      attribute :has_residential_use, :boolean
      validates :has_residential_use, inclusion: { in: [true, false] }

      before_save do
        self.completed = !has_residential_use
      end
    end
  end
end
