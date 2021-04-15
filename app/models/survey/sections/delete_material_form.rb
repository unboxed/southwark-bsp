module Survey
  module Sections
    class DeleteMaterialForm < BaseForm
      self.permit_attributes = [
        :confirm_deletion
      ]

      attribute :material, :model, model: Material
      attribute :materials, :collection, collection: MaterialList, item: Material

      attribute :confirm_deletion, :enum, values: %w[yes no]
      validates :confirm_deletion, inclusion: { in: %w[yes no] }

      before_transition do
        record.material = nil
      end

      before_save if: :delete_material? do
        materials.delete(material.id)
      end

      def delete_material?
        confirm_deletion == "yes"
      end

      def next_stage
        "external_walls_summary"
      end
    end
  end
end
