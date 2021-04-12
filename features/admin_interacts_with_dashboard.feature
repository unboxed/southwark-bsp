Feature: Admin views and edits buildings on dashboard
  Scenario: Admin can see relevant content
    Given I am on the dashboard
    Then the dashboard contains all expected columns
    And the dashboard contains the expected building information

  Scenario: Admin cannot see dashboard when not signed in
    Given I try to sign in with bad credentials
    Then I should not see the dashboard content

  Scenario: Admin can mark building as 'on Delta'
    Given I am on the dashboard
    When I mark building as 'on Delta'
    Then the 'on Delta' column contains "Yes"

