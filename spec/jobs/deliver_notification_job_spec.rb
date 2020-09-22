require "rails_helper"

RSpec.describe DeliverNotificationJob, "#perform" do
  it "attempts to deliver the notification" do
    notification = create :email_notification, building: create(:building)
    notifier_spy = spy
    expect(NotificationClient).to receive(:new).with(notification).and_return notifier_spy

    DeliverNotificationJob.perform_now notification

    expect(notifier_spy).to have_received :deliver
  end

  it "updates the notification with data from the notifier response if successful" do
    notification = create :email_notification, state: "created", building: create(:building)
    mock_notifier = double :notifier
    mock_response = double :mock_response, uri: "http://someplace.fun/1", id: SecureRandom.uuid

    allow(mock_notifier).to receive(:deliver).and_return mock_response
    expect(NotificationClient).to receive(:new).with(notification).and_return mock_notifier

    DeliverNotificationJob.perform_now notification

    expect(notification.state).to eq "sent"
    expect(notification.notify_uri).to eq mock_response.uri
    expect(notification.notify_id).to eq mock_response.id
    expect(notification.sent_at.to_date).to eq Date.today
  end
end
