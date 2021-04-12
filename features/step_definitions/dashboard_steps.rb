Given('I am on the dashboard') do
  steps %(
    Given I am on the sign in page
    And there is a building in the system
    And I log in
  )
end

Given('I am on the sign in page') do
  visit "/admin"
end

And('there is a building in the system') do
  @building = FactoryBot.create(:building)
end

And('I log in') do
  @admin = FactoryBot.create(:user)

  fill_in "Email address", with: @admin.email
  fill_in "Password", with: @admin.password
  click_button "Sign in"
end

Then('the dashboard contains all expected columns') do
  column_headers = ["UPRN", "Building",	"Owner", "Last emailed", "Letter sent", "EWS survey", "On Delta?"]
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

When('I mark building as {string}') do |_string|
  page.find("#building_building_id_").check
  click_button("Mark as 'on Delta'")
end

Then('the {string} column contains {string}') do |_string, _string2|
  within(".delta") do
    expect(page).to have_content("Yes")
  end
end

Given('I try to sign in with bad credentials') do
  visit "/admin"

  fill_in 'Email address', with: "fake@example.com"
  fill_in 'Password', with: "unknown"
  click_button 'Sign in'
end

Then('I should not see the dashboard content') do
  expect(page).not_to have_content("Dashboard")
end
