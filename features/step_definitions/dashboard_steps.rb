Given('I am on the dashboard') do
  steps %(
    Given I am on the sign in page
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

Then("the row for UPRN {int} contains {string} in the {string} column") do |uprn, value, column|
  # find the relevant column in the table eader
  col = page.find("thead tr th", text: column)

  raise "No `#{column}' column found" if col.nil?

  # use the xpath (.path) of the column to figure out its index within siblings
  # it's in the shape: '"/foo/bar/etc.../table/form/thead/tr/th[8]"
  # so we grab the last digit and we have our index
  index = col.path.match(/\[(\d+)\]$/)[1]

  # find the row with a corresponding UPRN and assert on the table
  # division (column) for that index
  within(page.find("tr", text: uprn)) do
    expect(page.find("td:nth-child(#{index})")).to have_content(value)
  end
end

Then("the building's row contains {string} in the {string} column") do |value, column|
  steps %(
    Then the row for UPRN #{@building.uprn} contains "#{value}" in the "#{column}" column
  )
end

Then('I should see a table row for UPRN {int}') do |uprn|
  steps %(
    Then the row for UPRN #{uprn} contains "#{uprn}" in the "UPRN" column
  )
end

Then("I should see {int} building record(s)") do |count|
  expect(page.all("tbody tr").length).to eq count
end

When("I filter the buildings with {string} as {string}") do |attr, value|
  within(".filters") do
    within("fieldset", text: attr) do
      choose value
    end
  end

  click_button "Filter"
end

Then("the page contains the building's {}") do |property|
  attr = property.parameterize.underscore

  expect(page).to have_content(@building.send(attr))
end

When("I select UPRN {int}") do |uprn|
  page.find("tr", text: uprn).find("input[type=checkbox]").check
end
