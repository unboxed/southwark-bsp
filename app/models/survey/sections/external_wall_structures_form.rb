module Survey
  module Sections
    class ExternalWallStructuresForm < BaseForm
      EXTERNAL_WALLS_STRUCTURES = %w[
        none
        balconies
        solar_shading
        green_walls
        other
      ].freeze

      attribute :structures, :list, values: EXTERNAL_WALLS_STRUCTURES, default: []
      validates :structures, presence: true

      attribute :structures_details, :string
      validates :structures_details, presence: true, length: { maximum: 100 }, if: :other_structures?

      validate do
        if no_structures? && structures.many?
          errors.add :structures, :invalid
        end
      end

      before_save do
        self.completed = !(balcony_structures? || solar_shading_structures?)
      end

      def next_stage
        if completed
          "check_your_answers"
        elsif balcony_structures?
          "balcony_materials"
        elsif solar_shading_structures?
          "solar_shading_materials"
        else
          stage # something is wrong if we get here
        end
      end

      def structure_options
        EXTERNAL_WALLS_STRUCTURES
      end

      def no_structures?
        structures.include?("none")
      end

      def other_structures?
        structures.include?("other")
      end

      def balcony_structures?
        structures.include?("balconies")
      end

      def solar_shading_structures?
        structures.include?("solar_shading")
      end

      def permit(params)
        if params.respond_to? :permit
          params.permit(:structures_details, structures: [])
        else
          params
        end
      end
    end
  end
end
