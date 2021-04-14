Feature: Alex fills in the Residential use section
  Background:
    Given a building survey at stage "residential_use"

  Scenario: Alex completes the residential use section
    Given I choose "Hotel"
    And I press "Continue"
    Then the page contains "Building management details"

  Scenario: Alex does not indicate the residential use
    Given I press "Continue"
    Then the page contains an error about "Please indicate the main residential use"
