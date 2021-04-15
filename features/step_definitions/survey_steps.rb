Given('I am on the home page') do
  visit root_path
end

Given('a building exists with UPRN {int}') do |uprn|
  @building = FactoryBot.create(:building, uprn: uprn)
end

Given('a building survey at stage {string}') do |stage|
  survey = FactoryBot.create(:survey, stage: stage)
  set_session_id(survey.session_id)

  visit "/survey"
end

Given('a survey has been completed for UPRN {int}') do |uprn|
  building = Building.find_by(uprn: uprn)

  @survey = FactoryBot.create(:survey, :completed, building: building, uprn: uprn)
end

Given('a material {string} that covers {string} of the building and is insulated with {string}') do |material, coverage, insulation|
  steps %(
    When I press "Add material"
    Then the page contains "Add an external wall material"
    When I choose "#{material}" for "Add an external wall material"
    And I press "Continue"
    Then the page contains "Provide details about ‘#{material}’"
    When I choose "#{coverage}" for "How much of the total external wall does this material cover?"
    And I choose "#{insulation}" for "Which insulation is used in combination with this material?"
    And I press "Continue"
    Then the page contains "External features of the building"
    And I should see the following within "External wall materials"
      | Material    | Insulation    | Percentage  |
      | #{material} | #{insulation} | #{coverage} |
  )
end

When('I start filling a survey for a building') do
  @building = FactoryBot.create(:building)

  steps %(
    Given I am on the home page
    And I press "Start now"
    And I fill in "What is the building’s UPRN?" with "#{@building.uprn}"
    And I press "Continue"
  )

  expect(page.current_path).to_not end_with "/get_started"
end

When('I fill in the user details') do
  steps %(
    Given I fill in "Full name" with "Alex Turner"
    And I fill in "Email" with "alex@example.com"
    And I choose "Managing agent"
  )
end

When('I say the building is used for residential purpose') do
  steps %(
    Given the page contains "Is any part of the building used for residential purposes?"
    And I choose "Yes"
  )
end

When('I choose the building residential use') do
  steps %(
    Given the page contains "What is the residential part of the building mainly used for?"
    And I choose "Student accommodation"
  )
end

When('I say who manages the building') do
  steps %(
    Given the page contains "Building management details"
    And I choose "Yes, the building is managed by a RTM company"
    And I fill in "Company name" with "Ringo"
    And I fill in "Building owner" with "Paul"
    And I fill in "Building developer" with "John"
    And I fill in "Managing agent" with "George"
  )
end

When('I fill in the height information') do
  steps %(
    Given the page contains "Building height"
    And I fill in "Height in metres" with "39"
    And I fill in "Number of storeys" with "5"
  )
end

When('I amend {string}') do |attribute|
  within('div', class: "govuk-summary-list__row", text: attribute) do
    click_on "Change"
  end
end

When('I move to the {string} stage') do |section|
  visit "/survey/#{section}"
end

When('I press {string} for the material {string}') do |button, material|
  within(:material, material) do
    click_on button
  end
end
