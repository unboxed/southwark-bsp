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
    to_show = []
    to_show << "#{ownership_status.humanize}"
    to_show << "#{self.ownership_details ? 'Details: ' + self.ownership_details : '' }"
    to_show << "#{self.full_name}"
    to_show << " #{self.email}"
    to_show << " #{self.organisation}"
    string = to_show.join(" ")
    to_show.each do |word|
      if word.blank? == false
        string.gsub!(/#{word}/i, "<span>#{word}</span><br>")
      end
    end
    string.html_safe
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
