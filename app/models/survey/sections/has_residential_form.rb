module Survey
  module Sections
    class HasResidentialForm < BaseForm
      attribute :has_residential_use, type: :boolean
      validates :has_residential_use, presence: true
    end
  end
end
