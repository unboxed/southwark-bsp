class Building < ApplicationRecord
  has_one :survey

  validates :uprn, presence: true, uniqueness: true

  scope :ordered_by_uprn, -> { order uprn: :asc }
end
