class BuildingWallMaterial < ApplicationRecord
  belongs_to :building_wall
  has_one :building_wall_material_percentage
  has_one :building_wall_material_insulation
  has_one :section, as: :content

  validates :material_name, presence: true, allow_blank: false

  def should_terminate_survey?
    false
  end
end
