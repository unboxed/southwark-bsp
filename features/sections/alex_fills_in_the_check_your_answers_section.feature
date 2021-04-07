Feature: Alex fills in the check_your_answers section
  Background:
    Given a building survey at stage "check_your_answers"

  Scenario: Alex completes the check_your_answers section
    Given I press "Submit"
    Then the next page is "Building survey complete"

  Scenario: Alex amends a part of the survey
    Given I move to the "ownership" stage
    And I fill in "Full name" with "Steph"
    And I fill in "Email" with "steph@steph.com"
    And I choose "Building developer"
    And I press "Continue"
    And I move to the "check_your_answers" stage
    And I amend "Full name"
    And I fill in "Full name" with "Bruno"
    And I press "Continue"
    Then the page contains "Check your answers"
    And the page contains "Bruno"

  Scenario: Alex completes a survey and can fill in a new one
    Given I press "Submit"
    And I press "fill a new survey"
    Then the next page is "What is the building's UPRN"
