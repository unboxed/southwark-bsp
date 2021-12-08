require 'textacular/searchable'

class Building < ApplicationRecord
  has_many :surveys, class_name: "Survey::Record", dependent: :destroy
  has_many :notifications, dependent: :destroy

  has_one :survey, -> { latest_completed }, class_name: "Survey::Record"
  has_one :letter, -> { letter_notifications.ordered_by_most_recent }, class_name: "Notification"

  validates :uprn, presence: true, uniqueness: true

  scope :ordered_by_uprn, -> { order uprn: :asc }

  extend Searchable(:uprn, :building_name, :land_registry_proprietor_name)

  include Browseable
  include DeltaCsvMapper

  scope :show, -> { preload(:survey, :letter).order(uprn: :asc) }
  scope :export, -> { in_state(:accepted).joins(:survey).merge(Survey::Record.residential_use).by_most_recent_transition_update.reverse }
  scope :by_most_recent_transition_update, -> { order('most_recent_building_survey_transition.updated_at DESC') }

  facet :all, -> { show.all }

  SurveyStateMachine.states.each do |state|
    facet state.to_sym, -> { in_state(state).by_most_recent_transition_update }
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

    def by_latest_survey
      references(:survey).order(survey_completed_at.desc)
    end

    private

    def survey_completed_at
      Survey::Record.arel_table[:completed_at]
    end
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
    survey_state.in_state?(:received, :accepted)
  end

  def other_survey_allowed?
    !survey_protected?
  end

  private

    def proprietor_address
      ProprietorAddress.new self
    end
end
