Feature: Admin views and edits buildings on dashboard
  Scenario: Admin can see relevant content
    Given I am on the dashboard
    Then the dashboard contains all expected columns
    And the page contains "A place full of wonders"
    And the page contains "1 Union Street"
    And the page contains "NW1235"

  Scenario: Admin cannot see dashboard when not signed in
    Given I am on the login page
    And I fill in "Email address" with "fake@example.com"
    And I fill in "Password" with "password"
    When I press "Sign in"
    Then the page contains an error about "There was a problem signing in"
    And I should not see the dashboard content

  Scenario: Admin can mark building as 'on Delta'
    Given I am on the dashboard
    When I mark building as on Delta
    Then the on Delta column contains "Yes"
