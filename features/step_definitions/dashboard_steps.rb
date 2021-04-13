Given('I am on the dashboard') do
  steps %(
    Given I am on the sign in page
    And a building exists with UPRN 1234567890
    And I log in
  )
end

Given('I am on the sign in page') do
  visit "/admin"
end

And('I log in') do
  @admin = FactoryBot.create(:user)

  fill_in "Email address", with: @admin.email
  fill_in "Password", with: @admin.password
  click_button "Sign in"
end

Then('the dashboard contains all expected columns') do
  column_headers = ["UPRN", "Building", "Owner", "Last emailed", "Letter sent", "EWS survey", "On Delta?"]
  column_headers.each do |header|
    expect(page).to have_content(header)
  end
end

Then('the dashboard contains the expected building information') do
  building_info = [@building.uprn, @building.street, @building.postcode]
  building_info.each do |field|
    expect(page).to have_content(field)
  end
end

When('I mark building as on Delta') do
  page.find("#building_building_id_").check
  click_button("Mark as 'on Delta'")
end

Given('I am on the login page') do
  visit "/admin"
end

Then('I should not see the dashboard content') do
  expect(page).not_to have_content("Dashboard")
end

Then('the on Delta column contains {string}') do |string|
  within(".delta") do
    expect(page).to have_content(string)
  end
end
