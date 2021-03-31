Feature: Alex fills in the ownership section

  Background:
    Given a building exists with UPRN 12345
    Given I am on the home page
    And I press "Start now"
    Given I fill in "Unique Property Reference Number" with "12345"
    And I press "Continue"

  Scenario: Alex completes the ownership section
    Given I fill in "Full name" with "Alex"
    And I fill in "Email" with "alex@alex.com"
    And I choose "Building owner"
    And I press "Continue"
    Then the page contains "Is any part of the building used for residential purposes?"

  Scenario: Alex doesn't indicate their role
    Given I fill in "Full name" with "Alex"
    Given I fill in "Email" with "alex@alex.com"
    And I press "Continue"
    Then the page contains an error about "role"

  Scenario: Alex indicates another role but doesn't provide details
    Given I fill in "Full name" with "Alex"
    Given I fill in "Email" with "alex@alex.com"
    And I choose "Other"
    And I press "Continue"
    Then the page contains an error about "Please provide details about your role"
