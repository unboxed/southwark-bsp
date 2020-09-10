class BuildingWallMaterialPercentage < ApplicationRecord
  belongs_to :building_wall_material
  has_one :section, as: :content

  def should_terminate_survey?
    false
  end
end
