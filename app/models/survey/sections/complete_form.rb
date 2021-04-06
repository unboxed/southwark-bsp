module Survey
  module Sections
    class CompleteForm < BaseForm
      attribute :field, :string
      validates :field, length: { maximum: 100 }, presence: true
    end
  end
end
