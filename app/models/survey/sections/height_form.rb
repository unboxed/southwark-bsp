module Survey
  module Sections
    class HeightForm < BaseForm
      attribute :height_in_metres, :float
      validates :height_in_metres, numericality: { greater_than: 0, allow_blank: true }

      attribute :number_of_storeys, :integer
      validates :number_of_storeys, numericality: { greater_than: 0, only_integer: true, allow_blank: true }

      validates :height_in_metres, presence: true, unless: ->(survey) { survey.number_of_storeys.present? }
      validates :number_of_storeys, presence: true, unless: ->(survey) { survey.height_in_metres.present? }

      def next_stage
        completed ? "check_your_answers" : "external_walls_summary"
      end
    end
  end
end
