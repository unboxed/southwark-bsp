class BuildingStatus < ApplicationRecord
  belongs_to :survey
  has_one :section, as: :content

  enum status: { existing: 1, demolished: 2, duplicate: 3, not_recognized: 4 }

  def name
    "Building status"
  end

  def reply
    status.humanize
  end

  def should_terminate_survey?
    !existing?
  end
end
