class BuildingTenure < ApplicationRecord
  belongs_to :survey

  enum tenure_type: { social_residential: 1, private_residential: 2, student_accomodation: 3, hotel: 4 }

  def should_terminate_survey?
    false
  end
end
