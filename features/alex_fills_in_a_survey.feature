Feature: Alex fills in a report about a building
  Scenario: Alex enters an invalid UPRN number
    Given I am on the home page
    And I press "Start now"
    And I fill in "survey_uprn" with "42"
    And I press "Continue"
    Then the page contains an error about "couldn't find a building with that UPRN"

  Scenario: Alex completes a building survey
    Given I start filling a survey for a building
    And I fill in the user details
    And I press "Continue"
    And I say the building is used for residential purpose
    And I press "Continue"
    And I choose the building residential use
    And I press "Continue"
    And I say who manages the building
    And I press "Continue"
    And I fill in the height information
    And I press "Continue"
    Then the page contains "You haven't added any materials yet."
