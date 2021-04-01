module Survey
  module Sections
    class AddMaterialForm < BaseForm
      MATERIALS = %w[
        glass
        high_pressure_laminate
        aluminium_composite_material
        other_metal_composite_material
        metal_sheet_panels
        render_system
        brick_slips
        brick
        stone_panels_or_stone
        tiling_systems
        timber_or_wood
        plastic
        other
        unknown
      ].freeze

      attribute :material, :string
      validates :material, inclusion: MATERIALS

      attribute :material_details, :string
      validates :material_details, presence: true, length: { maximum: 100 }, if: :other_material?

      def materials
        MATERIALS
      end

      def other_material?
        material == "other"
      end
    end
  end
end
