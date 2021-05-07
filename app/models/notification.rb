class Notification < ApplicationRecord
  belongs_to :building

  validates :building, presence: true
  validates :notification_mean, inclusion: { in: %w(email letter) }
  validates :state, inclusion: { in: %w(created enqueued sent delivered failed) }

  scope :for_building, -> (building) { where building: building }
  scope :letter_notifications, -> { where notification_mean: "letter" }
  scope :email_notifications, -> { where notification_mean: "email" }
  scope :ordered_by_most_recent, -> { order created_at: :desc }

  delegate :parsed_proprietor_address, to: :building

  def self.most_recent_for_each_notification_mean(building)
    [
      for_building(building).email_notifications.ordered_by_most_recent.first,
      for_building(building).letter_notifications.ordered_by_most_recent.first
    ].compact
  end

  def self.create_letter!(now = Time.current)
    create!(notification_mean: "letter", state: :enqueued, enqueued_at: now)
  end

  def summary
    notification_state_summary
  end

  def deliverable_by_email?
    notification_mean == "email"
  end

  def deliverable_by_letter?
    notification_mean == "letter"
  end

  def addressed_to
    building.proprietor_email if deliverable_by_email?
  end

  private

    def notification_state_summary
      case state
      when "created"
        "#{notification_mean.capitalize} created on #{created_at.to_date}."
      when "sent"
        "#{notification_mean.capitalize} was sent on #{sent_at.to_date}."
      when "delivered"
        "#{notification_mean.capitalize} was delivered on #{delivered_at.to_date}."
      when "failed"
        "#{notification_mean.capitalize} cannot be delivered to the specified email address."
      else
        "No summary available"
      end
    end
end
