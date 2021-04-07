Feature: Alex fills in the check_your_answers section
  Background:
    Given a building survey at stage "check_your_answers"

  Scenario: Alex completes the check_your_answers section
    Given I press "Submit"
    Then the next page is "Complete"
