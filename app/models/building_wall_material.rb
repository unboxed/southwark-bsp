class BuildingWallMaterial < ApplicationRecord
  belongs_to :building_wall

  def should_terminate_survey?
    false
  end
end
