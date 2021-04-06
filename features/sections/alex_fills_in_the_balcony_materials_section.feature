Feature: Alex fills in the balcony materials section
  Background:
    Given a building survey at stage "balcony_materials"

  Scenario: Alex completes the balcony materials sectinos
    Given I choose "Metal" for "Which material is the main balcony structure made from?"
    And I check "Glass" for "Which materials are the balcony floors made from?"
    And I check "Glass" for "Which materials are the balcony balustrade and/or railings made from?"
    And I press "Continue"
    Then the next page is "Solar shading"

  Scenario Outline: Alex chooses other fields but doesn't fill the details
    Given I choose "Do not know" for "Which material is the main balcony structure made from?"
    And I check "Do not know" for "Which materials are the balcony floors made from?"
    And I check "Do not know" for "Which materials are the balcony balustrade and/or railings made from?"

    And I <method> "Other" for "<section>"
    When I press "Continue"
    Then the page contains an error about "<validation>"

    Scenarios:
      | section                                    | validation                                                            | method |
      | Which material is the main balcony         | Please describe the other materials used on this building's balconies | choose |
      | Which materials are the balcony floors     | Please describe the other materials for the balcony floors            | check  |
      | Which materials are the balcony balustrade | Please describe the other materials for the balcony balustrade        | check  |
