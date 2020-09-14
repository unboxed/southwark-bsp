class BuildingOwnership < ApplicationRecord
  belongs_to :survey
  has_one :section, as: :content

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
end
