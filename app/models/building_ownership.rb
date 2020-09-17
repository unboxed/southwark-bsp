class BuildingOwnership < ApplicationRecord
  belongs_to :survey
  has_one :section, as: :content
  validates :ownership_status, presence: { message: "Select your role as either building owner, freeholder, building developer, managing agent, other, or if you are not associated with this building" }
  validate :association_to_building

  enum ownership_status: { building_owner_freeholder: 1, building_developer: 2, managing_agent: 3, other: 4, i_am_not_associated_with_this_building: 5 }

  def name
    "Building ownership"
  end

  def reply
    "#{ownership_status.humanize} details:#{self.ownership_details ? self.ownership_details : 'none' } #{self.full_name} #{self.email} #{self.organisation}"
  end

  def should_terminate_survey?
    i_am_not_associated_with_this_building?
  end

  def association_to_building
    if !i_am_not_associated_with_this_building? && (self.full_name.blank? || self.email.blank? || self.organisation.blank?)
      errors.add(:empty_details, "Please provide contact details")
    end
  end
end
