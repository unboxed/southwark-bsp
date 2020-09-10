require "rails_helper"

RSpec.describe "Admin signs in" do
  it "to view dashboard" do
    user = create :user

    visit "/admin"

    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_on "Sign in"

    expect(page).to have_content "Admin dashboard"

    click_link "Sign out"

    expect(current_path).to eq root_path
    expect(page).not_to have_link "Dashboard", href: admin_dashboard_path
  end
end
