module Survey
  module Sections
    class AddMaterialForm < MaterialForm
      def next_stage
        "add_material_details"
      end
    end
  end
end
