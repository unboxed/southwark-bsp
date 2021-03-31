Feature: Alex fills in the building management section

  Background:
    Given a building exists with UPRN 12345
    And I am on the home page
    And I press "Start now"
    And I fill in "Unique Property Reference Number" with "12345"
    And I press "Continue"
    And I fill in "Full name" with "Alex"
    And I fill in "Email" with "alex@alex.com"
    And I choose "Building owner"
    And I press "Continue"
    And I choose "Yes"
    And I press "Continue"
    And I choose "Hotel"
    And I press "Continue"

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
