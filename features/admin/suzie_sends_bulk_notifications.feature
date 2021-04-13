Feature: Suzie the admin can send bulk emails and letters to building owners
  Scenario: Suzie can see correct information on the emails form
    Given I am on the dashboard
    When I select buildings and press "Send email"
    Then the page contains "2 buildings selected"
    And the page contains "Do you want to send external wall systems emails to these building owners?"

  Scenario: Suzie can see correct information on the letters form
    Given I am on the dashboard
    When I select buildings and press "Send letter"
    Then the page contains "2 buildings selected"
    And the page contains "Do you want to send external wall systems letters to these building owners?"

  Scenario: Suzie can see correct message on emails form when no buildings selected
    Given I am on the dashboard
    When I press "Send letter"
    Then the page contains "No buildings selected"

  Scenario: Suzie can send letters
    Given I am on the dashboard
    When I select buildings and press "Send letter"
    And I choose "Yes"
    And I press "Continue"
    Then I should see the current date in the "letter" column

  Scenario: Suzie can send emails
    Given I am on the dashboard
    When I select buildings and press "Send letter"
    And I choose "Yes"
    And I press "Continue"
    Then I should see the current date in the "email" column
