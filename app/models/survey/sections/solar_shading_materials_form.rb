module Survey
  module Sections
    class SolarShadingMaterialsForm < BaseForm
      MATERIALS = %w[
        timber_or_wood
        glass
        metal
        concrete
        other
        unknown
      ].freeze

      self.permit_attributes = [
        :solar_shading_materials_details,
        { solar_shading_materials: [] }
      ]

      delegate :structures, to: :record

      attribute :solar_shading_materials, :list, values: MATERIALS, default: []
      validates :solar_shading_materials, presence: true

      attribute :solar_shading_materials_details, :string
      validates :solar_shading_materials_details, presence: true, length: { maximum: 100 }, if: :other_solar_shading_materials?

      validate do
        if unknown_materials? && solar_shading_materials.many?
          errors.add :solar_shading_materials, :invalid
        end
      end

      before_save do
        self.completed = true
      end

      def next_stage
        "check_your_answers"
      end

      def other_solar_shading_materials?
        solar_shading_materials.include?("other")
      end

      def unknown_materials?
        solar_shading_materials.include?("unknown")
      end

      def balcony_structures?
        structures.include?("balconies")
      end
    end
  end
end
