module Survey
  module Sections
    class ExternalWallStructuresForm < BaseForm
      EXTERNAL_WALLS_STRUCTURES = %w(
        balconies
        solar_shading
        green_walls
        other
      )

      attribute :structures, :string
      validates :structures, length: { maximum: 100 }, presence: true

      attribute :structures_details, :string
      validates :structures_details, length: { maximum: 100 }, presence: true, if: :other_structures?

      def structures
        EXTERNAL_WALLS_STRUCTURES
      end

      def other_structures?
        structures.any? { |s| s == "other" }
      end
    end
  end
end
