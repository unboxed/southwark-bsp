Feature: Alex fills in the ownership section
  Background:
    Given a building survey at stage "ownership"

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
