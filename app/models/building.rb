require 'textacular/searchable'

class Building < ApplicationRecord
  has_many :surveys, class_name: "Survey::Record", dependent: :destroy
  has_many :notifications

  has_one :survey, -> { latest_completed }, class_name: "Survey::Record"
  has_one :letter, -> { letter_notifications.ordered_by_most_recent }, class_name: "Notification"

  validates :uprn, presence: true, uniqueness: true

  scope :ordered_by_uprn, -> { order uprn: :asc }

  extend Searchable(:uprn, :building_name, :land_registry_proprietor_name)

  include Browseable
  include DeltaCsvMapper

  filter :delta_state, ->(name) { get_delta_state(name) }

  scope :show, -> { preload(:survey, :letter).order(uprn: :asc) }
  scope :export, -> { preload(:survey) }
  scope :completed, -> { joins(:surveys).where.not('survey_records.completed_at' => nil) }
  scope :not_received, -> { left_outer_joins(:surveys).where('survey_records.completed_at' => nil) }
  scope :on_delta, -> { where(on_delta: true) }
  scope :not_on_delta, -> { where.not(on_delta: true) }

  facet :all, -> { show.all }
  facet :completed, -> { show.completed }
  facet :not_received, -> { show.not_received }

  class << self
    def get_delta_state(name)
      case name
      when "on_delta"
        on_delta
      when "not_on_delta"
        not_on_delta
      else
        all
      end
    end

    def get_state(name)
      case name
      when "completed"
        completed
      when "not_received"
        not_received
      else
        all
      end
    end

    def mark_on_delta!(ids)
      transaction do
        where(id: ids).find_each(&:mark_on_delta!)
      end
    end

    def send_letters!(ids)
      where(id: ids).find_each(&:send_letter!)
    end
  end

  def mark_on_delta!
    update!(on_delta: true)
  end

  def send_letter!
    notification = notifications.create_letter!
    DeliverNotificationJob.perform_later(notification)
  end

  def address
    [
      building_name,
      street,
      city_town,
      postcode
    ].reject(&:blank?).join("\n")
  end

  def most_recent_notifications
    Notification.most_recent_for_each_notification_mean(self)
  end

  def parsed_proprietor_address
    proprietor_address.parsed
  end

  private

    def proprietor_address
      ProprietorAddress.new self
    end
end
