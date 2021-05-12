Feature: Suzie the admin can send letters to building owners
  Background:
    Given a building exists with UPRN 123
    Given a building exists with UPRN 456

  @javascript
  Scenario: Suzie can see a summary of the letters she's about to send
    Given I am on the dashboard
    And I select UPRN 123
    And I select UPRN 456
    When I press "Send letter"
    Then the page contains "2 buildings selected"
    And the page contains "This will send 2 letters. Are you sure?"

  @javascript
  Scenario: Suzie can send letters
    Given I am on the dashboard
    And I select UPRN 123
    And I select UPRN 456
    And I press "Send letter"
    When I press "Yes, send the letters"
    Then the page contains "Letter requests sent."
    # Because this is a @javascript test, the CSS is rendered and the
    # survey status is upcased (it's a govuk-tag), hence why we need
    # "CONTACTED" here rather than the regular string.
    And the row for UPRN 123 contains "CONTACTED" in the "Status" column
    And the row for UPRN 456 contains "CONTACTED" in the "Status" column
