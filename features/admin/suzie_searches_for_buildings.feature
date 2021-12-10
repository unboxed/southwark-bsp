Feature: Suzie the admin searches for buildings on the admin
  Background:
    Given a building exists with UPRN 1234567890
    And a building exists with UPRN: 1234567891, name: "Southwark House", postcode: "SE1 2QH", street: "Tooley Street", city: "Manchester"
    And I am logged into the admin

  Scenario: Suzie can find a building by UPRN
    Given I fill in "Search" with "1234567891"
    When I press "Search"
    Then the page contains "Building search results (1)"
    When I press "1234567891"
    Then the page contains "Edit building details"

  Scenario: Suzie can find a building by building name
    Given I fill in "Search" with "Southwark House"
    When I press "Search"
    Then the page contains "Building search results (1)"
    When I press "1234567891"
    Then the page contains "Edit building details"

  Scenario: Suzie can find a building by postcode
    Given I fill in "Search" with "SE1 2QH"
    When I press "Search"
    Then the page contains "Building search results (1)"
    When I press "1234567891"
    Then the page contains "Edit building details"

  Scenario: Suzie can find a building by street
    Given I fill in "Search" with "Tooley Street"
    When I press "Search"
    Then the page contains "Building search results (1)"
    When I press "1234567891"
    Then the page contains "Edit building details"

  Scenario: Suzie can find a building by city
    Given I fill in "Search" with "Manchester"
    When I press "Search"
    Then the page contains "Building search results (1)"
    When I press "1234567891"
    Then the page contains "Edit building details"

  Scenario: Suzie searches for a non-existent building
    Given I fill in "Search" with "160 doesn't exist"
    When I press "Search"
    Then the page contains "Building search results (0)"

  Scenario: Suzie can navigate back to the search results page
    Given I fill in "Search" with "Tooley Street"
    When I press "Search"
    Then the page contains "Building search results (1)"
    When I press "1234567891"
    Then the page contains "Edit building details"
    When I press "Back to search results"
    Then the page contains "Building search results (1)"
