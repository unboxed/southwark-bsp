module Survey
  module Sections
    class BalconyMaterialsForm < BaseForm
      MAIN_MATERIALS = %w[
        timber_or_wood
        metal
        concrete
        other
        do_not_know
      ].freeze

      FLOOR_MATERIALS = %w[
        timber_or_wood
        glass
        metal
        concrete
        other
        do_not_know
      ].freeze

      OTHER_MATERIALS = FLOOR_MATERIALS.dup

      delegate :structures, to: :record

      attribute :balcony_main_material, :enum, values: MAIN_MATERIALS
      validates :balcony_main_material, presence: true

      attribute :balcony_main_material_details, :string
      validates :balcony_main_material_details, presence: true, length: { maximum: 100 }, if: :other_main_material?

      attribute :balcony_floor_materials, :list, values: FLOOR_MATERIALS, default: []
      validates :balcony_floor_materials, presence: true

      attribute :balcony_floor_materials_details, :string
      validates :balcony_floor_materials_details, presence: true, length: { maximum: 100 }, if: :other_floor_materials?

      attribute :balcony_railing_materials, :list, values: OTHER_MATERIALS, default: []
      validates :balcony_railing_materials, presence: true

      attribute :balcony_railing_materials_details, :string
      validates :balcony_railing_materials_details, presence: true, length: { maximum: 100 }, if: :other_railing_materials?

      validate do
        if do_not_know_floor_materials? && balcony_floor_materials.many?
          errors.add :balcony_floor_materials, :invalid
        end

        if do_not_know_railing_materials? && balcony_railing_materials.many?
          errors.add :balcony_railing_materials, :invalid
        end
      end

      before_save do
        self.completed = !solar_shading_structures?
      end

      def other_main_material?
        balcony_main_material == "other"
      end

      def other_floor_materials?
        balcony_floor_materials.include?("other")
      end

      def do_not_know_floor_materials?
        balcony_floor_materials.include?("do_not_know")
      end

      def other_railing_materials?
        balcony_railing_materials.include?("other")
      end

      def do_not_know_railing_materials?
        balcony_railing_materials.include?("do_not_know")
      end

      def solar_shading_structures?
        structures.include?("solar_shading")
      end

      def permit(params)
        if params.respond_to?(:permit)
          params.permit(
            :balcony_main_material,
            :balcony_main_material_details,
            :balcony_floor_materials_details,
            :balcony_railing_materials_details,
            balcony_floor_materials: [],
            balcony_railing_materials: []
          )
        else
          params
        end
      end

      def relevant?
        record.has_residential_use != false && record.structures&.include?("balconies")
      end
    end
  end
end
