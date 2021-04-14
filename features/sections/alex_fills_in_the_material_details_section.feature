Feature: Alex fills in the ownership section

  Background:
    Given a building survey at stage "material_details"

  @wip
  Scenario: Alex completes the add material section
    Given I fill in "Can you provide more details?" with "The glass is very shiny"
    And I choose "Mineral wool"
    And I fill in "Can you provide more details about the insulation" with "The insulation is lovely"
    And I press "Continue"
    # Then the page contains "Provide details about"

  @wip
  Scenario: Alex does not indicate an insulation material
    Given I press "Continue"
    Then the page contains an error about "Please indicate the insulation used with this material"
