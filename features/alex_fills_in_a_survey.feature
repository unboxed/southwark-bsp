Feature: Alex fills in a report about a building
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

  Scenario: Alex can go back to the previous stage
    Given a building survey at stage "height"
    Then the page contains "Building height"
    When I press "Back"
    Then the page contains "Building management details"

  Scenario: Alex only sees relevant sections when reviewing answers
    Given I start filling a survey for a building
    And I fill in the user details
    And I press "Continue"
    And the page contains "Is any part of the building used for residential purposes?"
    And I choose "No"
    And I press "Continue"
    Then the page contains "Check your answers"
    And the page doesn't contain "Building management"
