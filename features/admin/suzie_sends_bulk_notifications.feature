Feature: Suzie the admin can send bulk emails and letters to building owners
  Background:
    Given a building exists with UPRN 123
    Given a building exists with UPRN 456

  Scenario: Suzie can see a summary of the letters she's about to send
    Given I am on the dashboard
    And I select UPRN 123
    And I select UPRN 456
    When I press "Send letter"
    Then the page contains "2 buildings selected"
    And the page contains "This will send 2 letters. Are you sure?"

  Scenario: Suzie can send letters
    Given I am on the dashboard
    And I select UPRN 123
    And I select UPRN 456
    And I press "Send letter"
    When I press "Yes, send the letters"
    Then the page contains "Letter requests sent."
