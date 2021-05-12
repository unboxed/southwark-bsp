Feature: Suzie the admin interacts with a building
  Background:
    Given a building exists with UPRN 1234567890
    And a survey has been completed for UPRN 1234567890
    And I am on the dashboard
    And I look at the details page for UPRN 1234567890

  Scenario: Suzie sees details about a building
    Then the page contains "Building details"
    And the page contains "Edit building details"
    And the page contains "Survey details"
    And the page has button "Accept survey data"
    And the page has button "Reject survey data"

  Scenario: Suzie can review a survey and mark it as accepted
    Given I press "Accept survey data"
    And I look at the list of buildings
    Then the building's row contains "Accepted" in the "Status" column

  Scenario: Suzie can review a survey and mark it as rejected
    Given I press "Reject survey data"
    And I look at the list of buildings
    Then the building's row contains "Rejected" in the "Status" column

  Scenario Outline: Suzie only sees relevant survey actions
    Given I press "<button>"
    When I look at the details page for UPRN 1234567890
    Then the page has button "<opposite>"
    And the page does not have button "<button>"

    Scenarios:
      | button             | opposite           |
      | Accept survey data | Reject survey data |
      | Reject survey data | Accept survey data |
