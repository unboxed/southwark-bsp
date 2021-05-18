Feature: Suzie the admin interacts with a building
  Background:
    Given a building exists with UPRN 1234567890
    And a survey has been "received" for UPRN 1234567890
    And I am logged into the admin
    And I look at the details page for UPRN 1234567890

  Scenario: Suzie sees details about a building
    Then the page contains "Building details"
    And the page contains "Edit building details"
    And the page contains "Survey details"
    And the page has button "Accept survey data"
    And the page has button "Reject survey data"

  Scenario: Suzie can review a survey and mark it as accepted
    Given I press "Accept survey data"
    Then the building with UPRN 1234567890 is visible in the "Accepted" tab
    And the row for UPRN 1234567890 contains a date in the "Accepted on" column

  Scenario: Suzie can review a survey and mark it as rejected
    Given I press "Reject survey data"
    Then the building with UPRN 1234567890 is visible in the "Rejected" tab
    And the row for UPRN 1234567890 contains a date in the "Rejected on" column

  Scenario Outline: Suzie only sees relevant survey actions
    Given I press "<button>"
    When I look at the details page for UPRN 1234567890
    Then the page has button "<opposite>"
    And the page does not have button "<button>"

    Scenarios:
      | button             | opposite           |
      | Accept survey data | Reject survey data |
      | Reject survey data | Accept survey data |

  Scenario: Suzie can see an edit link for rejected surveys
    Given I press "Reject survey data"
    Then the page contains "the link below to edit their survey"
