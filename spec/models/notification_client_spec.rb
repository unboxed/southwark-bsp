require "rails_helper"

RSpec.describe NotificationClient, "#deliver" do
  context "for an email notification" do
    it "invokes the Notify client to send email with the correct data" do
      building = build_stubbed(
        :building,
        proprietor_email: "owner@example.com",
        land_registry_proprietor_name: "Zee Owner",
        building_name: "ACME Tower",
        street: "1 Infinite Loop",
        postcode: "ACME B12",
        uprn: "01234567890"
      )
      notification = build_stubbed :email_notification, building: building
      notifier = NotificationClient.new notification
      notify_client_spy = spy :notify_client_spy
      allow(notifier).to receive(:client).and_return notify_client_spy

      notifier.deliver

      expect(notify_client_spy).to have_received(:send_email).with(
        email_address: "owner@example.com",
        template_id: ENV.fetch("NOTIFY_EMAIL_TEMPLATE_ID"),
        reference: notification.id.to_s,
        personalisation: {
          full_name: "Zee Owner",
          building_name: "ACME Tower",
          address_line_1: "1 Infinite Loop",
          postal_code: "ACME B12",
          uprn: "01234567890",
          survey_link: "http://#{ENV.fetch("APPLICATION_HOST")}/?uprn=01234567890"
        }
      )
    end
  end
  context "for a letter notification" do
    it "invokes the Notify client to send a letter with the correct data" do
      building = build_stubbed(
        :building,
        proprietor_email: "owner@example.com",
        land_registry_proprietor_name: "Zee Owner",
        land_registry_proprietor_address: "Berkeley House, 304 Regents Park Road, London N3 2JX",
        building_name: "ACME Tower",
        street: "1 Infinite Loop",
        postcode: "ACME B12",
        uprn: "01234567890",
      )
      notification = build_stubbed :letter_notification, building: building
      notifier = NotificationClient.new notification
      notify_client_spy = spy :notify_client_spy
      allow(notifier).to receive(:client).and_return notify_client_spy

      notifier.deliver

      expect(notify_client_spy).to have_received(:send_letter).with(
        template_id: ENV.fetch("NOTIFY_LETTER_TEMPLATE_ID"),
        reference: notification.id.to_s,
        personalisation: {
          full_name: "Zee Owner",
          building_name: "ACME Tower",
          building_address_line_1: "1 Infinite Loop",
          building_postal_code: "ACME B12",
          uprn: "01234567890",
          survey_link: "http://#{ENV.fetch("APPLICATION_HOST")}/?uprn=01234567890",
          address_line_1: "Berkeley House",
          address_line_2: "304 Regents Park Road",
          address_line_3: "London",
          address_line_4: "N3 2JX",
          address_line_5: "",
          address_line_6: "",
          address_line_7: ""
        }
      )
    end
  end
end
