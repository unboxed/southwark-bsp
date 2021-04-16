module Survey
  module Sections
    class BalconyMaterialsForm < BaseForm
      MAIN_MATERIALS = %w[
        timber_or_wood
        metal
        concrete
        other
        unknown
      ].freeze

      MATERIALS = %w[
        timber_or_wood
        glass
        metal
        concrete
        other
        unknown
      ].freeze

      self.permit_attributes = [
        :balcony_main_material,
        :balcony_main_material_details,
        :balcony_floor_materials_details,
        :balcony_railing_materials_details,
        {
          balcony_floor_materials: [],
          balcony_railing_materials: []
        }
      ]

      delegate :structures, to: :record

      attribute :balcony_main_material, :enum, values: MAIN_MATERIALS
      validates :balcony_main_material, presence: true

      attribute :balcony_main_material_details, :string
      validates :balcony_main_material_details, presence: true, length: { maximum: 100 }, if: :other_main_material?

      attribute :balcony_floor_materials, :list, values: MATERIALS, default: []
      validates :balcony_floor_materials, presence: true

      attribute :balcony_floor_materials_details, :string
      validates :balcony_floor_materials_details, presence: true, length: { maximum: 100 }, if: :other_floor_materials?

      attribute :balcony_railing_materials, :list, values: MATERIALS, default: []
      validates :balcony_railing_materials, presence: true

      attribute :balcony_railing_materials_details, :string
      validates :balcony_railing_materials_details, presence: true, length: { maximum: 100 }, if: :other_railing_materials?

      validate do
        if unknown_floor_materials? && balcony_floor_materials.many?
          errors.add :balcony_floor_materials, :invalid
        end

        if unknown_railing_materials? && balcony_railing_materials.many?
          errors.add :balcony_railing_materials, :invalid
        end
      end

      before_save do
        self.completed = !solar_shading_structures?
      end

      def next_stage
        if completed
          "check_your_answers"
        elsif solar_shading_structures?
          "solar_shading_materials"
        else
          stage # something is wrong if we get here
        end
      end

      def other_main_material?
        balcony_main_material == "other"
      end

      def other_floor_materials?
        balcony_floor_materials.include?("other")
      end

      def unknown_floor_materials?
        balcony_floor_materials.include?("unknown")
      end

      def other_railing_materials?
        balcony_railing_materials.include?("other")
      end

      def unknown_railing_materials?
        balcony_railing_materials.include?("unknown")
      end

      def solar_shading_structures?
        structures.include?("solar_shading")
      end
    end
  end
end
