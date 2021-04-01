Feature: Alex fills in the ownership section

  Background:
    Given a building survey at stage "add_material"

  @wip
  Scenario: Alex completes the add material section
    Given I choose "Brick"
    And I press "Continue"
    Then the page contains "Provide details about"

  Scenario: Alex indicates an alternate material but doesn't provide details
    Given I choose "Other"
    And I press "Continue"
    Then the page contains an error about "Please provide details about this other material"
