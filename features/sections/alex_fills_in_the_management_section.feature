Feature: Alex fills in the building management section
  Background:
    Given a building survey at stage "building_management"

  Scenario: Alex completes the residential use section
    Given I choose "No"
    And I press "Continue"
    Then the page contains "Building height"

  Scenario: Alex does not indicate the RTM details
    Given I press "Continue"
    Then the page contains an error about "Please indicate whether this building is managed by a right-to-manage company"

  Scenario: Alex indicates a RTM company but doesn't provide details
    Given I choose "Yes, the building is managed by a RTM company"
    And I press "Continue"
    Then the page contains an error about "provide the name of the right-to-manage company"
