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
    When I filter the buildings with "Survey status" as "Completed"
    Then I should see 1 building record
    And the page contains "Building records: 1 filtered result (4 total)"

  Scenario: Suzie filters out buildings with completed surveys
    Given a survey has been completed for UPRN 1234567890
    And a building exists with UPRN 123
    And a building exists with UPRN 345
    And a building exists with UPRN 567
    And I am on the dashboard
    When I filter the buildings with "Survey status" as "Not received"
    Then I should see 3 building records
    And the page contains "Building records: 3 filtered results (4 total)"

  Scenario: Suzie filters out buildings that have been synced to DELTA
    Given a building exists with UPRN 123
    And the building with UPRN 123 is on DELTA
    And a survey has been completed for UPRN 123
    And a building exists with UPRN 456
    And a survey has been completed for UPRN 456
    And I am on the dashboard
    When I filter the buildings with "Delta status" as "On Delta"
    And I filter the buildings with "Survey status" as "Completed"
    Then I should see 1 building record
    And I should see a table row for UPRN 123

  @javascript
  Scenario: Suzie can't interact with the bulk actions if she hasn't selected any records
    Given I am on the dashboard
    Then I can't press the "Send letter" button
    And I can't press the "Mark as 'on Delta'" button
    When I select UPRN 1234567890
    Then the page has button "Send letter"
    Then the page has button "Mark as 'on Delta'"
