require "rails_helper"

RSpec.describe "Callbacks - Notification Status" do
  context "for a request without authentication" do
    it "returns a 401 response" do
      post(
        callbacks_notification_statuses_path(format: :json),
        params: { some_random_param: true }.to_json,
        headers: { "CONTENT_TYPE" => "application/json" }
      )

      expect(response.status).to eq 401
    end
  end
  context "if the notification was successfully delivered" do
    it "updates to notification to delivered" do
      notification = create :email_notification, building: create(:building)

      post(
        callbacks_notification_statuses_path(format: :json),
        params: notification_body_for(notification, "delivered"),
        headers: notification_headers
      )

      notification.reload
      expect(response.status).to eq 201
      expect(notification.state).to eq "delivered"
      expect(notification.delivered_at.to_date).to eq Date.today
    end
  end
  context "if the notification could not be delivered due to a temporary failure" do
    it "enqueues the notification for retrying the send" do
      notification = create :email_notification, building: create(:building)

      expect(DeliverNotificationJob).to receive(:perform_later).with notification

      post(
        callbacks_notification_statuses_path(format: :json),
        params: notification_body_for(notification, "temporary-failure"),
        headers: notification_headers
      )

      notification.reload
      expect(response.status).to eq 201
      expect(notification.state).to eq "enqueued"
    end
  end
  context "if the notification could not be delivered due to a permanent failure" do
    it "sets the notification to failed" do
      notification = create :email_notification, building: create(:building)

      post(
        callbacks_notification_statuses_path(format: :json),
        params: notification_body_for(notification, "permanent-failure"),
        headers: notification_headers
      )

      notification.reload
      expect(response.status).to eq 201
      expect(notification.state).to eq "failed"
      expect(notification.failed_at.to_date).to eq Date.today
    end
  end
end

def notification_body_for(notification, status)
  {
    id: "",
    reference: notification.id.to_s,
    to: "",
    status: status,
    created_at: "",
    completed_at: DateTime.current,
    sent_at: "",
    notification_type: "",
  }.to_json
end

def notification_headers
  {
    "CONTENT_TYPE" => "application/json",
    "Authorization" => "Bearer #{ENV.fetch("NOTIFY_CALLBACK_TOKEN")}"
  }
end
