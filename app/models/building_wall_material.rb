class BuildingWallMaterial < ApplicationRecord
  belongs_to :building_wall
  has_one :building_wall_material_insulation

  enum material: {
    glass: "Glass",
    laminate:  "High pressure laminate",
    aluminium: "Aluminium composite material",
    metalcomposite: "Other metal composite material",
    brickslips: "Brick slips",
    brick: "Brick",
    stone: "Stone panels or stone",
    tilling: "Tilling systems",
    timberwood: "Timber or wood",
    plastic: "Plastic"
  }

  def should_terminate_survey?
    false
  end
end
