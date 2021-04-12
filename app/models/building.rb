class Building < ApplicationRecord
  has_one :survey
  has_many :notifications

  validates :uprn, presence: true, uniqueness: true

  scope :ordered_by_uprn, -> { order uprn: :asc }

  def most_recent_notifications
    Notification.most_recent_for_each_notification_mean(self)
  end

  def parsed_proprietor_address
    proprietor_address.parsed
  end

  def self.update_building_collection(commit_params, ids)
    Building.where(id: [ids]).update(on_delta: 1) if commit_params == "Mark as 'on Delta'"
  end

  private

    def proprietor_address
      ProprietorAddress.new self
    end
end
