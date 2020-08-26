class BuildingOwnership < ApplicationRecord
  belongs_to :survey
  has_one :section, as: :content

  enum ownership_status: { owner_freeholder: 1, developer: 2, managing_agent: 3, unknown: 4 }

  def name
    "Building ownership"
  end

  def reply
    ownership_status.humanize
  end

  def should_terminate_survey?
    false
  end
end
