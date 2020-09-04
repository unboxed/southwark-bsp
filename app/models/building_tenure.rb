class BuildingTenure < ApplicationRecord
  belongs_to :survey
  has_one :section, as: :content
  validates :tenure_type, presence: { message: "can't be blank. Please select one value from the list" }

  enum tenure_type: { social_residential: 1, private_residential: 2, student_accomodation: 3, hotel: 4 }

  def name
    "Building tenure"
  end

  def reply
    tenure_type.humanize
  end

  def should_terminate_survey?
    false
  end
end
