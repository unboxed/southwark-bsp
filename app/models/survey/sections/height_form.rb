module Survey
  module Sections
    class HeightForm < BaseForm
      attribute :height_in_metres, :float
      validates :height_in_metres, numericality: { greater_than: 0, allow_blank: true }

      attribute :number_of_storeys, :integer
      validates :number_of_storeys, numericality: { greater_than: 0, only_integer: true, allow_blank: true }

      def relevant?
        record.has_residential_use != false
      end
    end
  end
end
