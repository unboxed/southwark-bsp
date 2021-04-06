module Survey
  module Sections
    class ExternalWallStructuresForm < BaseForm
      EXTERNAL_WALLS_STRUCTURES = %w[
        balconies
        solar_shading
        green_walls
        other
      ].freeze

      attribute :structures, ListType.new(String)
      validates :structures, length: { maximum: 100 }, presence: true

      attribute :structures_details, :string
      validates :structures_details, length: { maximum: 100 }, presence: true, if: :other_structures?

      def structure_options
        EXTERNAL_WALLS_STRUCTURES
      end

      def other_structures?
        structures&.any? { |s| s == "other" }
      end

      def permit(params)
        super(params)

        if params.respond_to? :permit
          params.permit(:structures_details, structures: [])
        else
          params
        end
      end
    end
  end
end
