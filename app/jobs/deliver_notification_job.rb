class DeliverNotificationJob < ApplicationJob
  queue_as :default

  def perform(notification)
    client_response = NotificationClient.new(notification).deliver

    if client_response
      notification.update!(
        notify_uri: client_response.uri,
        notify_id: client_response.id,
        state: :sent,
        sent_at: DateTime.current,
      )
    end
  end
end
