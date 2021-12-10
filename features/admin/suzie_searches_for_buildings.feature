Feature: Suzie the admin searches for buildings on the admin
  Background:
    Given a building exists with UPRN: 1234567890, name: "Southwark House"
    And a building exists with UPRN: 1234567891, name: "Bradley House"
    And a building exists with UPRN: 1234567892, address: "160 Tooley Street, London SE1 2QH"
    And I am logged into the admin

  Scenario: Suzie can find a building by UPRN
    Given I fill in "Search" with "1234567890"
    When I press "Search"
    Then the page contains "Building search results (1)"
    When I press "1234567890"
    Then the page contains "Edit building details"

  Scenario: Suzie can find a building by building name
    Given I fill in "Search" with "Southwark House"
    When I press "Search"
    Then the page contains "Building search results (1)"
    When I press "1234567890"
    Then the page contains "Edit building details"

  Scenario: Suzie can find a building by postcode
    Given I fill in "Search" with "SE1 2QH"
    When I press "Search"
    Then the page contains "Building search results (1)"
    When I press "1234567892"
    Then the page contains "Edit building details"

  Scenario: Suzie can find a building by address
    Given I fill in "Search" with "160 Tooley street"
    When I press "Search"
    Then the page contains "Building search results (1)"
    When I press "1234567892"
    Then the page contains "Edit building details"

  Scenario: Suzie searches for a non-existent building
    Given I fill in "Search" with "160 doesn't exist"
    When I press "Search"
    Then the page contains "Building search results (0)"

  Scenario: Suzie can navigate back to the search results page
    Given I fill in "Search" with "160 Tooley street"
    When I press "Search"
    Then the page contains "Building search results (1)"
    When I press "1234567892"
    Then the page contains "Edit building details"
    When I press "Back to search results"
    Then the page contains "Building search results (1)"
