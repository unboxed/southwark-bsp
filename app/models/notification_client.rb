require "notifications/client"

class NotificationClient
  include Rails.application.routes.url_helpers

  attr_reader :client, :notification

  def initialize(notification)
    @notification = notification
    @client = Notifications::Client.new(ENV.fetch("NOTIFY_API_KEY"))
  end

  def deliver
    if notification.deliverable_by_email?
      client.send_email(
        email_address: notification.addressed_to,
        template_id: ENV.fetch("NOTIFY_EMAIL_TEMPLATE_ID"),
        reference: notification.id.to_s,
        personalisation: {
          full_name: notification.building.land_registry_proprietor_name,
          building_name: notification.building.building_name,
          address_line_1: notification.building.street,
          postal_code: notification.building.postcode,
          uprn: notification.building.uprn,
          survey_link: get_started_url(uprn: notification.building.uprn, host: ENV.fetch("APPLICATION_HOST"))
        }
      )
    end
  end
end
