module Survey
  module Sections
    class EditMaterialForm < MaterialForm
      def next_stage
        "edit_material_details"
      end
    end
  end
end
