Feature: Alex fills in the height section
  Background:
    Given a building survey at stage "height"

  Scenario: Alex completes the building height section
    Given I fill in "Height in metres" with "18"
    And I fill in "Number of storeys" with "10"
    And I press "Continue"
    Then the page contains "External features of the building"

  Scenario: Alex does not fill in any heights
    Given I press "Continue"
    Then the page contains an error about "You must fill in at least one box. If you don't know the building's height in metres, please tell us the number of storeys."
    Then the page contains an error about "You must fill in at least one box. If you don't know the number of storeys, please tell us the building's height in metres."

  Scenario: Alex fills in only the height in metres
    Given I fill in "Height in metres" with "18"
    And I press "Continue"
    Then the page contains "External features of the building"

  Scenario: Alex fills in only the number of storeys
    Given I fill in "Number of storeys" with "10"
    And I press "Continue"
    Then the page contains "External features of the building"
