class BuildingWallMaterialPercentage < ApplicationRecord
  belongs_to :building_wall_material

  def should_terminate_survey?
    false
  end
end
