Feature: Alex fills in the external wall structures section
  Background:
    Given a building survey at stage "external_wall_structures"

  @wip
  Scenario: Alex completes the external wall structures section
    Given I choose "Green walls"
    And I press "Continue"
    Then the page contains "Provide details about"

  Scenario: Alex indicates an alternate wall structure but doesn't provide details
    Given I check "Other"
    And I press "Continue"
    Then the page contains an error about "Please describe the other external wall structures"
