module Survey
  module Sections
    class SolarShadingMaterialsForm < BaseForm
      SOLAR_SHADING_MATERIALS = %w[
        timber_or_wood
        glass
        metal
        concrete
        do_not_know
        other
      ]

      attribute :solar_shading_materials, ListType.new(String)
      validates :solar_shading_materials, presence: true

      attribute :solar_shading_materials_details, :string
      validates :solar_shading_materials_details, presence: true, if: :other_solar_shading_materials?

      def solar_shading_materials_options
        SOLAR_SHADING_MATERIALS
      end

      def other_solar_shading_materials?
        solar_shading_materials.detect { |m| m == "other" }
      end

      def permit(params)
        super(params)

        if params.respond_to? :permit
          params.permit(
            :solar_shading_materials_details,
            solar_shading_materials: []
          )
        else
          params
        end
      end
    end
  end
end
