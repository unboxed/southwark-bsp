class BuildingHeight < ApplicationRecord
  belongs_to :survey
  has_one :section, as: :content

  def name
    "Building height"
  end

  def reply
    "#{overall_height_data} - #{height_in_storeys} storey(s), #{height_in_meters} meters"
  end

  def should_terminate_survey?
    !higher_than_18_meters?
  end

  def incomplete?
    (height_in_meters.nil? && height_in_storeys.nil?) ||
      (!height_in_meters.nil? && height_in_storeys.nil?) ||
      (height_in_meters.nil? && !height_in_storeys.nil?)
  end

  private

    def overall_height_data
      if higher_than_18_meters?
        "Taller than 18 meters"
      else
        "Under 18 meters tall"
      end
    end
end
