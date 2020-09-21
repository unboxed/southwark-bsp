class BuildingHeight < ApplicationRecord
  belongs_to :survey
  has_one :section, as: :content

  validates_inclusion_of :higher_than_18_meters, in: [true, false], message: 'Please select one'


  def name
    "Building height"
  end

  def reply
    "#{overall_height_data} #{self.height_in_meters ? '- ' + self.height_in_meters.to_s + ' meters' : ''}  #{self.height_in_storeys ? self.height_in_storeys.to_s + ' storey(s)' : ''}"
  end

  def should_terminate_survey?
    !higher_than_18_meters
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
