module Survey
  module Sections
    class AddMaterialDetailsForm < MaterialDetailsForm
      before_save do
        materials.append(material)
      end
    end
  end
end
