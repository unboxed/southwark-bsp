require "rails_helper"

RSpec.describe Notification, "associations" do
  it { is_expected.to belong_to :building }
end

RSpec.describe Notification, "validations" do
  it { is_expected.to validate_presence_of :building }
  it { is_expected.to validate_inclusion_of(:notification_mean).in_array %w(email letter) }
  it { is_expected.to validate_inclusion_of(:state).in_array %w(created enqueued sent delivered failed) }
end

RSpec.describe Notification, ".for_building" do
  it "returns notifications for a specific building" do
    building = create :building
    other_building = create :building
    notification = create :email_notification, building: building
    other_notification = create :email_notification, building: other_building

    for_building = Notification.for_building building

    expect(for_building).to eq [notification]
    expect(for_building).not_to include(other_notification)
  end
end

RSpec.describe Notification, ".letter_notifications" do
  it "returns only letter notifications" do
    letter_notification = create :letter_notification, building: create(:building)
    email_notification = create :email_notification, building: create(:building)

    letter_notifications = Notification.letter_notifications

    expect(letter_notifications).to eq [letter_notification]
    expect(letter_notifications).not_to include(email_notification)
  end
end

RSpec.describe Notification, ".email_notifications" do
  it "returns only email notifications" do
    letter_notification = create :letter_notification, building: create(:building)
    email_notification = create :email_notification, building: create(:building)

    email_notifications = Notification.email_notifications

    expect(email_notifications).to eq [email_notification]
    expect(email_notifications).not_to include(letter_notification)
  end
end

RSpec.describe Notification, ".ordered_by_most_recent" do
  it "returns notifications ordered most recent to least recent" do
    email_notification = create :email_notification, building: create(:building), created_at: Date.today
    letter_notification = create :letter_notification, building: create(:building), created_at: Date.yesterday

    ordered_notifications = Notification.ordered_by_most_recent

    expect(ordered_notifications).to eq [email_notification, letter_notification]
  end
end

RSpec.describe Notification, ".most_recent_for_each_notification_mean" do
  it "returns the most recent email notification and the most recent letter notification" do
    building = create(:building)
    most_recent_email_notification = create :email_notification, building: building, created_at: Date.today
    email_notification = create :letter_notification, building: building, created_at: Date.yesterday
    other_email_notification = create :letter_notification, building: create(:building), created_at: Date.today
    letter_notification = create :letter_notification, building: create(:building), created_at: Date.yesterday
    most_recent_letter_notification = create :letter_notification, building: building, created_at: Date.today
    other_letter_notification = create :letter_notification, building: create(:building), created_at: Date.today

    most_recent_notifications = Notification.most_recent_for_each_notification_mean(building)

    expect(most_recent_notifications).to eq [most_recent_email_notification, most_recent_letter_notification]
  end
end

RSpec.describe Notification, ".most_recent_for_each_notification_mean" do
  it "returns the most recent email notification and the most recent letter notification" do
    building = create(:building)
    most_recent_email_notification = create :email_notification, building: building, created_at: Date.today
    email_notification = create :letter_notification, building: building, created_at: Date.yesterday
    other_email_notification = create :letter_notification, building: create(:building), created_at: Date.today
    letter_notification = create :letter_notification, building: create(:building), created_at: Date.yesterday
    most_recent_letter_notification = create :letter_notification, building: building, created_at: Date.today
    other_letter_notification = create :letter_notification, building: create(:building), created_at: Date.today

    most_recent_notifications = Notification.most_recent_for_each_notification_mean(building)

    expect(most_recent_notifications).to eq [most_recent_email_notification, most_recent_letter_notification]
  end

  it "returns only a letter notification if an email notification doesnt exist" do
    building = create(:building)
    letter_notification = create :letter_notification, building: create(:building), created_at: Date.yesterday
    most_recent_letter_notification = create :letter_notification, building: building, created_at: Date.today

    most_recent_notifications = Notification.most_recent_for_each_notification_mean(building)

    expect(most_recent_notifications).to eq [most_recent_letter_notification]
  end

  it "returns only an email notification if a letter notification doesnt exist" do
    building = create(:building)
    most_recent_email_notification = create :email_notification, building: building, created_at: Date.today
    other_email_notification = create :email_notification, building: building, created_at: Date.yesterday

    most_recent_notifications = Notification.most_recent_for_each_notification_mean(building)

    expect(most_recent_notifications).to eq [most_recent_email_notification]
  end

  it "returns an empty collection if no notifications exist" do
    building = create :building

    most_recent_notifications = Notification.most_recent_for_each_notification_mean building

    expect(most_recent_notifications).to eq []
  end
end

RSpec.describe Notification, "#summary" do
  context "returns a description adequate to the notification mean and state" do
    context "for an email notification with a state of created" do
      it "indicates an email notification was created on a date" do
        notification = build_stubbed :email_notification, state: "created"

        summary = notification.summary

        expect(summary).to eq "Email created on #{notification.created_at.to_date}."
      end
    end
    context "for an email notification with a state of sent" do
      it "indicates an email notification was sent" do
        notification = build_stubbed :email_notification, state: "sent", sent_at: DateTime.current

        summary = notification.summary

        expect(summary).to eq "Email was sent on #{notification.sent_at.to_date}."
      end
    end
    context "for an email notification with a state of delivered" do
      it "indicates an email notification was delivered" do
        notification = build_stubbed :email_notification, state: "delivered", delivered_at: DateTime.current

        summary = notification.summary

        expect(summary).to eq "Email was delivered on #{notification.delivered_at.to_date}."
      end
    end
    context "for an email notification with a state of failed" do
      it "indicates an email notification failed to deliver" do
        notification = build_stubbed :email_notification, state: "failed", failed_at: DateTime.current

        summary = notification.summary

        expect(summary).to eq "Email cannot be delivered to the specified email address."
      end
    end
    context "for a letter notification with a state of created" do
      it "indicates a letter notification was created on a date" do
        notification = build_stubbed :letter_notification, state: "created"

        summary = notification.summary

        expect(summary).to eq "Letter created on #{notification.created_at.to_date}."
      end
    end
    context "for a letter notification with a state of sent" do
      it "indicates a letter notification was sent" do
        notification = build_stubbed :letter_notification, state: "sent", sent_at: DateTime.current

        summary = notification.summary

        expect(summary).to eq "Letter was sent on #{notification.sent_at.to_date}."
      end
    end
    context "for an letter notification with a state of delivered" do
      it "indicates an letter notification was delivered" do
        notification = build_stubbed :letter_notification, state: "delivered", delivered_at: DateTime.current

        summary = notification.summary

        expect(summary).to eq "Letter was delivered on #{notification.delivered_at.to_date}."
      end
    end
  end
end

RSpec.describe Notification, "#deliverable_by_email?" do
  it "returns true if the notification mean is set to email" do
    notification = build :email_notification

    email_deliverable = notification.deliverable_by_email?

    expect(email_deliverable).to eq true
  end

  it "returns false if the notification mean is not set to email" do
    notification = build :letter_notification

    email_deliverable = notification.deliverable_by_email?

    expect(email_deliverable).to eq false
  end
end

RSpec.describe Notification, "#address_to" do
  context "for an email notification" do
    it "returns the associated building's proprietor email" do
      building = build :building, proprietor_email: "owner@example.com"
      notification = build :email_notification, building: building

      addressee = notification.addressed_to

      expect(addressee).to eq "owner@example.com"
    end
  end
end
