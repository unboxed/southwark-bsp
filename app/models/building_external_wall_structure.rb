class BuildingExternalWallStructure < ApplicationRecord
  belongs_to :survey
  has_one :section, as: :content

  def name
    "External walls structures"
  end

  def reply
    [self].inject([]) do |replies, external_wall|
      replies.push "Balconies" if external_wall.has_balconies?
      replies.push "Solar shading" if external_wall.has_solar_shading?
      replies.push "Green walls" if external_wall.has_green_walls?
      replies.push "Other structure" if external_wall.has_other_structure?
      replies.push "No external structures" if external_wall.has_no_external_structures?
      replies
    end.compact.join(", ")
  end

  def should_terminate_survey?
    true
  end
end
