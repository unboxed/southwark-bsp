Given('I am logged into the admin') do
  steps %(
    Given I am on the sign in page
    And I log in
  )
end

Given('I am on the sign in page') do
  visit "/admin"
end

Given('I look at the list of buildings') do
  visit "/admin"
end

And('I log in') do
  @admin = FactoryBot.create(:user)

  fill_in "Email address", with: @admin.email
  fill_in "Password", with: @admin.password
  click_button "Sign in"
end

Given('I am on the login page') do
  visit "/admin"
end

Then('I should not see the admin page') do
  expect(page).not_to have_content("All buildings")
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
    matcher = value.start_with?("/") ? eval(value) : value # rubocop:disable Security/Eval

    expect(page.find("td:nth-child(#{index})")).to have_content(matcher)
  end
end

Then('the row for UPRN {int} contains a date in the {string} column') do |uprn, column|
  datelike = "/\\d{1,2} \\w+ \\d{4}/"

  steps %(
    Then the row for UPRN #{uprn} contains "#{datelike}" in the "#{column}" column
  )
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
  check "Select building with the UPRN #{uprn}"
end

When('I look at the details page for UPRN {int}') do |uprn|
  visit admin_building_path(uprn: uprn)
end

Then('the building with UPRN {int} is visible in the {string} tab') do |uprn, status|
  steps %(
    Given I go to the "#{status}" tab
    Then I should see a table row for UPRN #{uprn}
  )
end

When('I go to the {string} tab') do |tab|
  steps %(
    When I look at the list of buildings
    And I press "#{tab}"
  )
end

Then('there is a search result for UPRN {int}') do |uprn|
  table = page.find(:table, "Search results")

  expect(table).to have_selector(:table_row, "UPRN" => uprn.to_s)
end
