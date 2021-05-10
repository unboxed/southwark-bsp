Feature: Suzie the admin interacts with a building
  Background:
    Given a building exists with UPRN 1234567890
    And a survey has been completed for UPRN 1234567890
    And I am on the dashboard
    And I look at the details page for UPRN 1234567890

  Scenario: Suzie sees details about a building
    Then the page contains "Building details"
    And the page contains "Edit building details"
