Given('I am on the home page') do
  visit root_path
end

Then('the page contains an error about {string}') do |msg|
  within(:css, 'div.govuk-error-summary') do
    expect(page).to have_content msg
  end
end

Given('I start filling a survey for a building') do
  @building = FactoryBot.create(:building)

  steps %(
    Given I am on the home page
    And I press "Start now"
    And I fill in "UPRN" with "#{@building.uprn}"
    And I press "Continue"
  )

  expect(page.current_path).to_not end_with "/get_started"
end

And('I fill in the user details') do
  steps %(
    Given I fill in "Full name" with "Alex Turner"
    And I fill in "Email" with "alex@example.com"
    And I choose "Managing agent"
  )
end
