Feature: Alex fills in the UPRN section

  Background:
    Given I am on the home page
    And I press "Start now"

  Scenario: Alex completes the UPRN section
    Given a building exists with UPRN 12345
    Given I fill in "Unique Property Reference Number" with "12345"
    And I press "Continue"
    Then the page contains "Your details"

  Scenario: Alex enters an invalid UPRN number
    Given I fill in "Unique Property Reference Number" with "42"
    And I press "Continue"
    Then the page contains an error about "couldn't find a building with that UPRN"
