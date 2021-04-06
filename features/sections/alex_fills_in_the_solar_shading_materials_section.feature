Feature: Alex fills in the solar shading materials section
  Background:
    Given a building survey at stage "solar_shading_materials"

  Scenario: Alex completes the solar shading materials section
    Given I check "Glass"
    And I press "Continue"
    Then the next page is "Complete"

  Scenario: Alex indicates an alternate solar shading material but doesn't provide details
    Given I check "Other"
    And I press "Continue"
    Then the page contains an error about "Please describe the other solar shading materials"
