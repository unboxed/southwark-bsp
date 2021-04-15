module Survey
  module Sections
    class DeleteMaterialForm < BaseForm
      self.permit_attributes = [
        :confirm_deletion
      ]

      attribute :material, :model, model: Material
      attribute :materials, :collection, collection: MaterialList, item: Material

      attribute :confirm_deletion, :boolean, default: false

      before_transition do
        record.material = nil
      end

      before_save if: :confirm_deletion do
        materials.delete(material.id)
      end

      def next_stage
        "external_walls_summary"
      end
    end
  end
end
