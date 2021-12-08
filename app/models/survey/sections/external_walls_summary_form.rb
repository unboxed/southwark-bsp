module Survey
  module Sections
    class ExternalWallsSummaryForm < BaseForm
      attribute :material_id, :string
      attribute :next_stage, :string, default: "external_wall_structures"
      attribute :materials, :collection, collection: MaterialList, item: Material, default: MaterialList.new
      attribute :validate_materials, :boolean, default: false

      delegate :min_coverage, :max_coverage, to: :materials

      validate if: :validate_materials do
        errors.add :materials, :blank if materials.empty?
        errors.add :min_coverage, :less_than_or_equal_to, count: 100 if min_coverage > 100
        errors.add :max_coverage, :greater_than_or_equal_to, count: 100 if max_coverage < 100
      end

      before_transition do
        record.material = case next_stage
                          when "delete_material", "edit_material"
                            materials.find(material_id)
                          end
      end

      def next_stage
        case super
        when "external_wall_structures"
          completed ? "check_your_answers" : super
        else
          super
        end
      end

      def can_continue?
        materials.size >= 1
      end

      def can_add_material?
        materials.size <= 10
      end
    end
  end
end
