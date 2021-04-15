module Survey
  module Sections
    class EditMaterialDetailsForm < MaterialDetailsForm
      before_save do
        materials.update(material)
      end
    end
  end
end
