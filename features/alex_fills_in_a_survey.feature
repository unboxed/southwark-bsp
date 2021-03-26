Feature: Alex fills in a report about a building
  Scenario: Alex enters an invalid UPRN number
    Given I am on the home page
    And I press "Start now"
    And I fill in "survey_uprn" with "42"
    And I press "Continue"
    Then the page contains an error about "couldn't find a building with that UPRN"

    And I press "Continue"
    Then I should see an error about "Sorry, we couldn't find a building with that UPRN"
