Feature: Suzie the admin views and edits buildings on dashboard
  Background:
    Given a building exists with UPRN 1234567890

  Scenario: Suzie can see relevant content
    Given I am on the dashboard
    Then the dashboard contains all expected columns
    And the page contains the building's building name
    And the page contains the building's street
    And the page contains the building's postcode

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

  Scenario: Suzie can mark building as 'on Delta'
    Given I am on the dashboard
    When I mark building as on Delta
    Then the on Delta column contains "Yes"

  Scenario: Suzie filters buildings
    Given a survey has been completed for UPRN 1234567890
    And a building exists with UPRN 123
    And a building exists with UPRN 345
    And a building exists with UPRN 567
    And I am on the dashboard
    And I open the filters
    And I check "Completed"
    And I press "Filter"
    Then I should see 1 building record
