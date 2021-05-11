module Survey
  module Summaries
    class FeaturesSummary < BaseSummary
      self.attribute_names = %i[materials structures]

      delegate *attribute_names, to: :record
      delegate :structures_details, to: :record
      delegate :balcony_main_material, to: :record
      delegate :balcony_main_material_details, to: :record
      delegate :balcony_floor_materials, to: :record
      delegate :balcony_floor_materials_details, to: :record
      delegate :balcony_railing_materials, to: :record
      delegate :balcony_railing_materials_details, to: :record
      delegate :solar_shading_materials, to: :record
      delegate :solar_shading_materials_details, to: :record

      def initialize(...)
        super

        self.attribute_names = []

        attribute_names << :materials
        attribute_names << :structures

        if structures.include?("balconies")
          attribute_names << :balcony_main_material
          attribute_names << :balcony_floor_materials
          attribute_names << :balcony_railings_materials
        end

        if structures.include?("solar_shading")
          attribute_names << :solar_shading_materials
        end
      end

      def value_for_materials
        render "surveys/materials_list", materials: materials_list
      end

      def value_for_structures
        simple_format(lookup_structures.join("\n"), class: "govuk-body")
      end

      def value_for_balcony_main_material
        lookup(balcony_main_material, :balcony_main_material, other: balcony_main_material_details)
      end

      def value_for_balcony_floor_materials
        simple_format(lookup_balcony_floors.join("\n"), class: "govuk-body")
      end

      def value_for_balcony_railings_materials
        simple_format(lookup_balcony_railings.join("\n"), class: "govuk-body")
      end

      def value_for_solar_shading_materials
        simple_format(lookup_solar_shading.join("\n"), class: "govuk-body")
      end

      def url_for_materials
        goto_path("external_walls_summary")
      end

      def url_for_structures
        goto_path("external_wall_structures")
      end

      def url_for_balcony_main_material
        goto_path("balcony_materials")
      end

      def url_for_balcony_floor_materials
        goto_path("balcony_materials")
      end

      def url_for_balcony_railings_materials
        goto_path("balcony_materials")
      end

      def url_for_solar_shading_materials
        goto_path("solar_shading_materials")
      end

      private

      def lookup_structures
        structures.map { |structure| lookup(structure, :structures, other: structures_details) }
      end

      def lookup_balcony_floors
        balcony_floor_materials.map { |floor| lookup(floor, :balcony_floor_materials, other: balcony_floor_materials_details) }
      end

      def lookup_balcony_railings
        balcony_railing_materials.map { |floor| lookup(floor, :balcony_railing_materials, other: balcony_railing_materials_details) }
      end

      def lookup_solar_shading
        solar_shading_materials.map { |floor| lookup(floor, :solar_shading_materials, other: solar_shading_materials_details) }
      end

      def materials_list
        MaterialList.new(materials.map { |material| Material.new(material) })
      end
    end
  end
end
