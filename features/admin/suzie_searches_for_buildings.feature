Feature: Suzie the admin searches for buildings on the admin
  Background:
    Given a building exists with UPRN 1234567890
    And a building exists with UPRN: 1234567891, name: "Southwark House", postcode: "SE1 2QH", street: "Tooley Street", city: "Manchester"
    And I am logged into the admin

  Scenario Outline: Suzie can search on multiple criteria
    Given I fill in "Search" with "<term>"
    When I press "Search"
    Then there is a search result for UPRN 1234567891

    Scenarios:
      | criteria | term            |
      | uprn     | 1234567891      |
      | address  | Southwark House |
      | postcode | SE1 2QH         |
      | street   | Tooley Street   |
      | city     | Manchester      |

  Scenario: Suzie searches for a non-existent building
    Given I fill in "Search" with "160 doesn't exist"
    When I press "Search"
    Then the page contains "Building search results (0)"

  Scenario: Suzie can navigate back to the search results page
    Given I fill in "Search" with "Tooley Street"
    When I press "Search"
    And I press "1234567891"
    And I press "Back to search results"
    Then the page contains "Building search results (1)"
