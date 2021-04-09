Given('I am on the home page') do
  visit root_path
end

Then('the page contains an error about {string}') do |msg|
  within(:css, 'div.govuk-error-summary') do
    expect(page).to have_content msg
  end
end

Given('a building exists with UPRN {int}') do |uprn|
  @building = FactoryBot.create(:building, uprn: uprn)
end

Given('I start filling a survey for a building') do
  @building = FactoryBot.create(:building)

  steps %(
    Given I am on the home page
    And I press "Start now"
    And I fill in "What is the building’s UPRN?" with "#{@building.uprn}"
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

And('I say the building is used for residential purpose') do
  steps %(
    Given the page contains "Is any part of the building used for residential purposes?"
    And I choose "Yes"
  )
end

And('I choose the building residential use') do
  steps %(
    Given the page contains "What is the residential part of the building mainly used for?"
    And I choose "Student accommodation"
  )
end

And('I say who manages the building') do
  steps %(
    Given the page contains "Building management details"
    And I choose "Yes, the building is managed by a RTM company"
    And I fill in "Company name" with "Ringo"
    And I fill in "Building owner" with "Paul"
    And I fill in "Building developer" with "John"
    And I fill in "Managing agent" with "George"
  )
end

And('I fill in the height information') do
  steps %(
    Given the page contains "Building height"
    And I fill in "Height in metres" with "39"
    And I fill in "Number of storeys" with "5"
  )
end

Given('a building survey at stage {string}') do |stage|
  survey = FactoryBot.create(:survey, stage: stage)
  set_session_id(survey.session_id)

  visit "/survey"
end

Given('I amend {string}') do |attribute|
  within('div', class: "govuk-summary-list__row", text: attribute) do
    click_on "Change"
  end
end

Given('I move to the {string} stage') do |section|
  visit "/survey/#{section}"
end
