class Building < ApplicationRecord
  has_many :surveys, class_name: "Survey::Record"
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
    Building.where(id: [ids]).update_all(on_delta: true) if commit_params == "Mark as 'on Delta'" # rubocop:disable Rails/SkipsModelValidations
  end

  def latest_survey
    surveys.order(completed_at: :desc).first
  end

  private

    def proprietor_address
      ProprietorAddress.new self
    end
end
