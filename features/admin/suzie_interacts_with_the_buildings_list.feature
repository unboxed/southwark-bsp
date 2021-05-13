Feature: Suzie the admin views and edits buildings on the admin
  Background:
    Given a building exists with UPRN 1234567890

  Scenario: Suzie can see relevant content
    Given I am logged into the admin
    And the page contains the building's building name
    And the page contains the building's street
    And the page contains the building's postcode
    And the page contains "Building records: 1 total"

  Scenario: Suzie can see buildings without surveys
    Given I am logged into the admin
    Then the building survey status is "not_contacted"

  Scenario: Suzie can see buildings with submitted surveys
    Given a survey has been completed for UPRN 1234567890
    And I am logged into the admin
    Then the building survey status is "received"

  Scenario: Suzie cannot see the admin if she isn't logged in
    Given I am on the login page
    And I fill in "Email address" with "fake@example.com"
    And I fill in "Password" with "password"
    When I press "Sign in"
    Then the page contains an error about "There was a problem signing in"
    And I should not see the admin page

  @javascript
  Scenario: Suzie can't interact with the bulk actions if she hasn't selected any records
    Given I am logged into the admin
    Then I can't press the "Send letter" button
    When I select UPRN 1234567890
    Then the page has button "Send letter"
