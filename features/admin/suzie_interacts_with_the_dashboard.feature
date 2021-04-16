Feature: Suzie the admin views and edits buildings on dashboard
  Background:
    Given a building exists with UPRN 1234567890

  Scenario: Suzie can see relevant content
    Given I am on the dashboard
    Then the dashboard contains all expected columns
    And the page contains the building's building name
    And the page contains the building's street
    And the page contains the building's postcode
    And the page contains "Building records: 1 total"

  Scenario: Suzie can see buildings without surveys
    Given I am on the dashboard
    Then the building's row contains "Not received" in the "EWS survey" column

  Scenario: Suzie can see buildings with submitted surveys
    Given a survey has been completed for UPRN 1234567890
    And I am on the dashboard
    Then the building's row contains "Completed on " in the "EWS survey" column

  Scenario: Suzie cannot see dashboard when not signed in
    Given I am on the login page
    And I fill in "Email address" with "fake@example.com"
    And I fill in "Password" with "password"
    When I press "Sign in"
    Then the page contains an error about "There was a problem signing in"
    And I should not see the dashboard content

  Scenario: Suzie can mark buildings as 'on Delta'
    Given a building exists with UPRN 111
    And a building exists with UPRN 222
    And a building exists with UPRN 333
    And I am on the dashboard
    When I select UPRN 111
    And I select UPRN 333
    And I press "Mark as 'on Delta'"
    Then the row for UPRN 111 contains "Yes" in the "On Delta?" column
    And the row for UPRN 333 contains "Yes" in the "On Delta?" column
    And the row for UPRN 222 contains "No" in the "On Delta?" column

  Scenario: Suzie filters out buildings with completed surveys
    Given a survey has been completed for UPRN 1234567890
    And a building exists with UPRN 123
    And a building exists with UPRN 345
    And a building exists with UPRN 567
    And I am on the dashboard
    When I filter the buildings with "Survey state" as "Completed"
    Then I should see 1 building record
    And the page contains "Building records: 1 filtered result (1 total)"

  Scenario: Suzie filters out buildings with completed surveys
    Given a survey has been completed for UPRN 1234567890
    And a building exists with UPRN 123
    And a building exists with UPRN 345
    And a building exists with UPRN 567
    And I am on the dashboard
    When I filter the buildings with "Survey state" as "Not received"
    Then I should see 3 building records
    And the page contains "Building records: 3 filtered results (3 total)"
