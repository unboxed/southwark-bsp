class BuildingOwnership < ApplicationRecord
  belongs_to :survey

  enum status: { owner_freeholder: 1, developer: 2, managing_agent: 3, unknown: 4 }

  def should_terminate_survey?
    false
  end
end
