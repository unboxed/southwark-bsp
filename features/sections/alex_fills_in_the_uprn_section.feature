Feature: Alex fills in the UPRN section

  Background:
    Given I am on the home page
    And I press "Start now"

  Scenario: Alex completes the UPRN section
    Given a building exists with UPRN 1234567890
    Given I fill in "What is the building’s UPRN?" with "1234567890"
    And I press "Continue"
    Then the page contains "Your details"

  Scenario: Alex enters a UPRN number that does not exist
    Given I fill in "What is the building’s UPRN?" with "1000000000"
    And I press "Continue"
    Then the page contains an error about "we couldn’t find a building with that UPRN"

  Scenario: Alex enters an invalid UPRN number
    Given I fill in "What is the building’s UPRN?" with "42"
    And I press "Continue"
    Then the page contains an error about "that URPN is invalid"
