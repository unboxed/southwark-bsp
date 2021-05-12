Feature: Alex fills in a report about a building
  Scenario: Alex completes a building survey
    Given I start filling a survey for a building
    And I fill in the user details
    And I press "Continue"
    And I say the building is used for residential purpose
    And I press "Continue"
    And I choose the building residential use
    And I press "Continue"
    And I say who manages the building
    And I press "Continue"
    And I fill in the height information
    And I press "Continue"
    And I fill in the wall material information
    And I press "Save and continue"
    And I fill in the wall structure information
    And I press "Continue"
    Then I see the summary "Your details" with
      | Name                        | Value                    | Link                             |
      | Full name                   | Alex Turner              | /survey/ownership                |
      | Email address               | alex@example.com         | /survey/ownership                |
      | Connection                  | Managing agent           | /survey/ownership                |
    And I see the summary "Building details" with
      | Name                        | Value                    | Link                             |
      | UPRN                        | 590642245244             | /survey/uprn                     |
      | Address                     | A place full of wonders  |                                  |
      | Usage                       | Student accommodation    | /survey/residential_use          |
      | Height                      | 39.0m                    | /survey/height                   |
      | Storeys                     | 5                        | /survey/height                   |
    And I see the summary "Building management" with
      | Name                        | Value                    | Link                             |
      | RTM company                 | Ringo                    | /survey/building_management      |
      | Building owner              | Paul                     | /survey/building_management      |
      | Building developer          | John                     | /survey/building_management      |
      | Managing agent              | George                   | /survey/building_management      |
    And I see the summary "External wall features" with
      | Name                        | Value                    | Link                             |
      | External walls              | Material Brick (40–60%)  | /survey/external_walls_summary   |
      | External structures         | Balconies                | /survey/external_wall_structures |
      | Balcony structure           | Metal                    | /survey/balcony_materials        |
      | Balcony floors              | Timber or wood           | /survey/balcony_materials        |
      | Balcony balustrade/railings | Metal                    | /survey/balcony_materials        |
      | Solar shading               | Timber or wood           | /survey/solar_shading_materials  |
    When I press "Submit survey"
    Then the page contains "Building survey complete"
    And the page contains "You have successfully submitted a survey for the building with UPRN 590642245244"

  Scenario: Alex can go back to the previous stage
    Given a building survey at stage "height"
    Then the page contains "Building height"
    When I press "Back"
    Then the page contains "Building management details"

  Scenario: Alex opens a survey link
    Given a building exists with UPRN 777
    When I open a survey link for UPRN 777
    Then the page contains "What is the building’s UPRN?"
    And the input for "UPRN" contains "777"

  Scenario: Alex tries to fill over a completed survey
    Given a building exists with UPRN 1234567890
    And a survey has been completed for UPRN 1234567890
    When I start filling a survey for UPRN 1234567890
    Then the page contains "Sorry, another survey is already under review"

  Scenario: Alex tries to fill over a rejected survey
    Given a building exists with UPRN 1234567890
    And a survey has been rejected for UPRN 1234567890
    When I start filling a survey for UPRN 1234567890
    Then the page contains "Your details"

  Scenario: Alex replaces a rejected survey
    Given a building exists with UPRN 1234567890
    And a survey has been rejected for UPRN 1234567890
    When I complete a survey for UPRN 1234567890
    Then the page contains "successfully submitted a survey"
