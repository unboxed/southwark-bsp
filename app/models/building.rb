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

  scope :show, -> { preload(:survey, :letter).order(uprn: :asc) }
  scope :export, -> { preload(:survey) }

  facet :all, -> { show.all }

  SurveyStateMachine.states.each do |state|
    facet state.to_sym, -> { in_state(state) }
  end

  class << self
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
    return unless land_registry_proprietor_address?

    notification = notifications.create_letter!
    DeliverNotificationJob.perform_later(notification)
  end

  has_many :survey_transitions, dependent: :destroy, autosave: false

  include Statesman::Adapters::ActiveRecordQueries[
            transition_class: Building::SurveyTransition,
            initial_state: :not_contacted
          ]

  def survey_state
    @survey_state ||= SurveyStateMachine.new(self, transition_class: Building::SurveyTransition, association_name: :survey_transitions)
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

  def survey_protected?
    survey_state.in_state?(:received, :accepted, :exported)
  end

  def other_survey_allowed?
    !survey_protected?
  end

  private

    def proprietor_address
      ProprietorAddress.new self
    end
end
