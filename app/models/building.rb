class Building < ApplicationRecord
  has_one :survey
  has_many :notifications

  validates :uprn, presence: true, uniqueness: true

  enum on_delta: { No: 0, Yes: 1 }

  scope :ordered_by_uprn, -> { order uprn: :asc }

  def most_recent_notifications
    Notification.most_recent_for_each_notification_mean(self)
  end

  def parsed_proprietor_address
    proprietor_address.parsed
  end

  def self.update_building_collection(commit_params, ids)
    if commit_params == "Mark as 'on Delta'"
      Building.where(id: [ids]).update_all(on_delta: 1)
    end
  end

  private

    def proprietor_address
      ProprietorAddress.new self
    end
end
