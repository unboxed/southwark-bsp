require "rails_helper"

RSpec.describe "Admin sends survey link" do
  include NotificationHelpers
  include SignInHelpers

  before { stub_notify_response }

  it "sending an email survey link" do
    create :building, proprietor_email: "proprietor@example.com"

    sign_in_as_admin
    click_on "Email survey link"

    expect(page).to have_content "Email was sent on #{Date.today}."
  end
end
