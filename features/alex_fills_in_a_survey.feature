Feature: Alex fills in a report about a building
  Scenario: Alex can start filling in a survey
    Given I am on the home page
    And I press "Start now"
    Then I should see "Get started"

  Scenario: Alex enters an invalid UPRN number
    Given I am on the home page
    And I press "Start now"
    And I fill in "survey_uprn" with "Doowap"
    And I press "Continue"
    Then I should see an error about "Sorry, we couldn't find a building with that UPRN"
