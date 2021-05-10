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
      client.send_email email_request_options
    elsif notification.deliverable_by_letter?
      client.send_letter letter_request_options
    end
  end

  private

    def email_request_options
      {
        email_address: notification.addressed_to,
        template_id: ENV.fetch("NOTIFY_EMAIL_TEMPLATE_ID"),
        reference: notification.id.to_s,
        personalisation: {
          full_name: notification.building.land_registry_proprietor_name,
          building_name: notification.building.building_name || "",
          address_line_1: notification.building.street || "",
          postal_code: notification.building.postcode || "",
          uprn: notification.building.uprn,
          survey_link: root_url(host: ENV.fetch("APPLICATION_HOST"))
        }
      }
    end

    def letter_request_options
      {
        template_id: ENV.fetch("NOTIFY_LETTER_TEMPLATE_ID"),
        reference: notification.id.to_s,
        personalisation: {
          address_line_1: notification.parsed_proprietor_address.fetch("line_0", ""),
          address_line_2: notification.parsed_proprietor_address.fetch("line_1", ""),
          address_line_3: notification.parsed_proprietor_address.fetch("line_2", ""),
          address_line_4: notification.parsed_proprietor_address.fetch("line_3", ""),
          address_line_5: notification.parsed_proprietor_address.fetch("line_4", ""),
          address_line_6: notification.parsed_proprietor_address.fetch("line_5", ""),
          address_line_7: notification.parsed_proprietor_address.fetch("line_6", ""),
          full_name: notification.building.land_registry_proprietor_name,
          building_name: notification.building.building_name || "",
          building_address_line_1: notification.building.street || "",
          building_postal_code: notification.building.postcode || "",
          uprn: notification.building.uprn,
          survey_link: root_url(host: ENV.fetch("APPLICATION_HOST"))
        }
      }
    end
end
