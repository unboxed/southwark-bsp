class BuildingHeight < ApplicationRecord
  belongs_to :survey

  def should_terminate_survey?
    !higher_than_18_meters?
  end
end
