Feature: Suzie the admin can send bulk emails and letters to building owners
  Background:
    Given a building exists with UPRN 1234567891
    Given a building exists with UPRN 1234567892

  Scenario: Suzie can see correct information on the letters form
    Given I am on the dashboard
    When I select buildings and press "Send letter"
    Then the page contains "2 buildings selected"
    And the page contains "This will send 2 letters. Are you sure?"

  Scenario: Suzie can send letters
    Given I am on the dashboard
    When I select buildings and press "Send letter"
    And I press "Yes, send the letters"
    Then I should see the current date in the "letter" column
