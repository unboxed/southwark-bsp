module Survey
  module Sections
    class MaterialDetailsForm < BaseForm
      COVERAGE = [10, 30, 50, 70, 90].freeze

      self.permit_attributes = [
        material_attributes: %i[
          details coverage insulation
          other_insulation insulation_details
        ]
      ]

      attribute :material, :model, model: Material
      accepts_nested_attributes_for :material

      attribute :materials, :collection, collection: MaterialList, item: Material

      with_options to: :material, prefix: true do
        delegate :details, :coverage, :insulation
        delegate :other_insulation, :insulation_details
      end

      delegate :other_insulation?, to: :material

      validates :material_details, length: { maximum: 100 }
      validates :material_coverage, inclusion: { in: COVERAGE }
      validates :material_insulation, presence: true
      validates :material_insulation_details, length: { maximum: 100 }
      validates :material_other_insulation, length: { maximum: 100 }
      validates :material_other_insulation, presence: true, if: :other_insulation?

      before_transition do
        case stage
        when "external_walls_summary"
          record.material = nil
        end
      end

      def next_stage
        "external_walls_summary"
      end
    end
  end
end
