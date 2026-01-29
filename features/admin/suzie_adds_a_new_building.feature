Feature: Suzie the admin adds a new building
  Background:
    Given I am logged into the admin

  Scenario: Suzie navigates to the add building page
    When I look at the list of buildings
    And I press "Add building"
    Then the page contains "Add a building record"

  Scenario: Suzie adds a new building
    When I look at the list of buildings
    And I press "Add building"
    Then the page contains "Add a building record"
    When I fill in the address information
    And I fill in the proprietor information
    And I press "Add building"
    Then the page contains "Building record successfully created"

  Scenario: Suzie sees a validation error when UPRN is missing
    When I look at the list of buildings
    And I press "Add building"
    Then the page contains "Add a building record"
    When I press "Add building"
    Then the page contains an error about "Please enter the UPRN of the building"

  Scenario: Suzie cannot add a building with a duplicate UPRN
    Given a building exists with UPRN 1234567890
    When I look at the list of buildings
    And I press "Add building"
    Then the page contains "Add a building record"
    When I fill in "UPRN" with "1234567890"
    And I press "Add building"
    Then the page contains an error about "A building with that UPRN already exists"
