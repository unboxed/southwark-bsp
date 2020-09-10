class BuildingWall < ApplicationRecord
  belongs_to :survey
  has_many :building_wall_materials, dependent: :destroy
  has_one :section, as: :content

  def name
    "Building wall"
  end

  def reply
  end

  def should_terminate_survey?
    false
  end
end
