require "rails_helper"
require "csv"

RSpec.describe "Admin signs in" do

  let!(:user) { create :user }

  it "to view dashboard" do
    visit "/admin"

    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_on "Sign in"

    expect(page).to have_content "Dashboard"

    click_link "Sign out"

    expect(current_path).to eq root_path
    expect(page).not_to have_link "Dashboard", href: admin_root_path
  end
end
