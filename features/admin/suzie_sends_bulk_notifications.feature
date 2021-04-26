Feature: Suzie the admin can send bulk emails and letters to building owners
  Background:
    Given a building exists with UPRN 1234567891
    Given a building exists with UPRN 1234567892

  Scenario: Suzie can see correct information on the letters form
    Given I am on the dashboard
    When I select buildings and press "Send letter"
    Then the page contains "2 buildings selected"
    And the page contains "Do you want to send external wall systems letters to these building owners?"

  Scenario: Suzie can send letters
    Given I am on the dashboard
    When I select buildings and press "Send letter"
    And I choose "Yes"
    And I press "Continue"
    Then I should see the current date in the "letter" column
