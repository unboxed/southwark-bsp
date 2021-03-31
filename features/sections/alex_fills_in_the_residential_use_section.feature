Feature: Alex fills in the Residential use section

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

  Scenario: Alex completes the residential use section
    Given I choose "Yes"
    And I press "Continue"
    Then the page contains "What is the residential part of the building"

  @wip
  Scenario: Alex enters an invalid UPRN number
    Given I choose "No"
    Then we need to figure out what happens then
