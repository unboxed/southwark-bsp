require "rails_helper"

RSpec.describe "Admin sends survey link" do
  include NotificationHelpers
  include SignInHelpers

  it "sending an email survey link" do
    stub_notify_email_response
    create :building, proprietor_email: "proprietor@example.com"

    sign_in_as_admin
    click_on "Email survey link"

    expect(page).to have_content "Email was sent on #{Date.today}."
  end

  it "sending a letter" do
    stub_notify_letter_response
    create :building, land_registry_proprietor_address: "1 Some Street, London, SE23 3RR"

    sign_in_as_admin
    click_on "Send survey letter"

    expect(page).to have_content "Letter was sent on #{Date.today}."
  end
end
