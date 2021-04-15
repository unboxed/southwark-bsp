module Survey
  module Sections
    class MaterialForm < BaseForm
      self.permit_attributes = [
        material_attributes: %i[type other_type]
      ]

      attribute :material, :model, model: Material, default: Material.new
      accepts_nested_attributes_for :material

      with_options to: :material, prefix: true do
        delegate :type, :other_type
      end

      validates :material_type, presence: true
      validates :material_other_type, length: { maximum: 100 }
      validates :material_other_type, presence: true, if: :other_material?

      before_transition do
        case stage
        when "external_walls_summary"
          record.material = nil
        end
      end

      def other_material?
        material.other?
      end

      def run_callbacks(kind, &block)
        if material && kind == :save
          material.run_callbacks(kind) do
            super(kind, &block)
          end
        else
          super(kind, &block)
        end
      end
    end
  end
end
