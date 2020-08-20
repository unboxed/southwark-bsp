class BuildingStatus < ApplicationRecord
  belongs_to :survey

  enum status: { existing: 1, demolished: 2, duplicate: 3, not_recognized: 4 }

  def should_terminate_survey?
    !existing?
  end
end
