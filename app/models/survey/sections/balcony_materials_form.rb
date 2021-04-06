module Survey
  module Sections
    class BalconyMaterialsForm < BaseForm
      MAIN_MATERIALS = %w[
        timber_or_wood
        metal
        concrete
        do_not_know
        other
      ].freeze

      FLOOR_MATERIALS = %w[
        timber_or_wood
        glass
        metal
        concrete
        do_not_know
        other
      ].freeze

      OTHER_MATERIALS = FLOOR_MATERIALS.dup

      attribute :balcony_main_material, :string
      validates :balcony_main_material, length: { maximum: 100 }, presence: true, inclusion: { in: MAIN_MATERIALS }

      attribute :balcony_main_material_details, :string
      validates :balcony_main_material_details, presence: true, if: :other_main_material?

      attribute :balcony_floor_materials, ListType.new(String)
      validates :balcony_floor_materials, presence: true

      attribute :balcony_floor_materials_details, :string
      validates :balcony_floor_materials_details, presence: true, if: :other_floor_materials?

      attribute :balcony_other_materials, ListType.new(String)
      validates :balcony_other_materials, presence: true

      attribute :balcony_other_materials_details, :string
      validates :balcony_other_materials_details, presence: true, if: :other_railing_materials?

      def main_materials
        MAIN_MATERIALS
      end

      def floor_materials
        FLOOR_MATERIALS
      end

      def other_materials
        OTHER_MATERIALS
      end

      def other_main_material?
        balcony_main_material == "other"
      end

      def other_floor_materials?
        balcony_floor_materials.detect { |m| m == "other" }
      end

      def other_railing_materials?
        balcony_other_materials.detect { |m| m == "other" }
      end

      def permit(params)
        super(params)

        if params.respond_to? :permit
          params.permit(
            :balcony_main_material,
            :balcony_main_material_details,
            :balcony_floor_material_details,
            balcony_floor_materials: [],
            balcony_other_materials: []
          )
        else
          params
        end
      end
    end
  end
end
