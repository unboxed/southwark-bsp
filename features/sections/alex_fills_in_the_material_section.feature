Feature: Alex fills in the material section
  Background:
    Given a building survey at stage "external_walls_summary"

  Scenario: Alex adds a material
    When I press "Add material"
    Then the page contains "Add an external wall material"
    When I choose "Glass" for "Add an external wall material"
    And I press "Continue"
    Then the page contains "Provide details about ‘Glass’"
    When I choose "20–40%" for "How much of the total external wall does this material cover?"
    And I choose "None" for "Which insulation is used in combination with this material?"
    And I press "Continue"
    Then the page contains "External features of the building"
    And I should see the following within "External wall materials"
      | Material | Insulation | Percentage |
      | Glass    | None       |     20–40% |

  Scenario: Alex doesn't indicate what the material is
    When I press "Add material"
    Then the page contains "Add an external wall material"
    When I press "Continue"
    Then the page contains an error about "Please indicate which material this wall is made of"

  Scenario: Alex indicates an alternate material but doesn't provide details
    When I press "Add material"
    Then the page contains "Add an external wall material"
    When I choose "Other" for "Add an external wall material"
    And I press "Continue"
    Then the page contains an error about "Please provide details about this other material"

  Scenario: Alex adds an alternate material
    When I press "Add material"
    Then the page contains "Add an external wall material"
    When I choose "Other" for "Add an external wall material"
    And I fill in "What is the material used?" with "Unobtainium"
    And I press "Continue"
    Then the page contains "Provide details about ‘Unobtainium’"
    When I choose "20–40%" for "How much of the total external wall does this material cover?"
    And I choose "None" for "Which insulation is used in combination with this material?"
    And I press "Continue"
    Then the page contains "External features of the building"
    And I should see the following within "External wall materials"
      | Material    | Insulation | Percentage |
      | Unobtainium | None       |     20–40% |

  Scenario: Alex adds a material with an alternate insulation
    When I press "Add material"
    Then the page contains "Add an external wall material"
    When I choose "Timber or wood" for "Add an external wall material"
    And I press "Continue"
    Then the page contains "Provide details about ‘Timber or wood’"
    When I choose "20–40%" for "How much of the total external wall does this material cover?"
    And I choose "Other" for "Which insulation is used in combination with this material?"
    And I fill in "Please list any other insulation materials" with "Spray Foam"
    And I press "Continue"
    Then the page contains "External features of the building"
    And I should see the following within "External wall materials"
      | Material         | Insulation | Percentage |
      | Timber or wood   | Spray Foam |     20–40% |

  Scenario: Alex adds a material with an alternate insulation but doesn't provide details
    When I press "Add material"
    Then the page contains "Add an external wall material"
    When I choose "Timber or wood" for "Add an external wall material"
    And I press "Continue"
    Then the page contains "Provide details about ‘Timber or wood’"
    When I choose "20–40%" for "How much of the total external wall does this material cover?"
    And I choose "Other" for "Which insulation is used in combination with this material?"
    And I press "Continue"
    Then the page contains an error about "Please provide details about this other insulation material"

  Scenario: Alex adds a second material
    Given a material "Brick" that covers "40–60%" of the building and is insulated with "Phenolic foam insulation"
    When I press "Add material"
    Then the page contains "Add an external wall material"
    When I choose "Glass" for "Add an external wall material"
    And I press "Continue"
    Then the page contains "Provide details about ‘Glass’"
    When I choose "20–40%" for "How much of the total external wall does this material cover?"
    And I choose "None" for "Which insulation is used in combination with this material?"
    And I press "Continue"
    Then the page contains "External features of the building"
    And I should see the following within "External wall materials"
      | Material | Insulation               | Percentage |
      | Brick    | Phenolic foam insulation |     40–60% |
      | Glass    | None                     |     20–40% |
    And I should see the following within "External wall materials"
      | Material         | Percentage |
      | Total percentage |    60–100% |

  Scenario: Alex edits a material
    Given a material "Brick" that covers "40–60%" of the building and is insulated with "Phenolic foam insulation"
    Given a material "Glass" that covers "20–40%" of the building and is insulated with "Mineral wool"
    When I press "Edit" for the material "Glass"
    Then the page contains "Update an external wall material"
    When I press "Continue"
    Then the page contains "Provide details about ‘Glass’"
    When I choose "40–60%" for "How much of the total external wall does this material cover?"
    And I choose "None" for "Which insulation is used in combination with this material?"
    And I press "Continue"
    Then the page contains "External features of the building"
    And I should see the following within "External wall materials"
      | Material | Insulation               | Percentage |
      | Brick    | Phenolic foam insulation |     40–60% |
      | Glass    | None                     |     40–60% |
    And I should see the following within "External wall materials"
      | Material         | Percentage |
      | Total percentage |    80–120% |

  Scenario: Alex deletes a material
    Given a material "Brick" that covers "40–60%" of the building and is insulated with "Phenolic foam insulation"
    Given a material "Glass" that covers "20–40%" of the building and is insulated with "Mineral wool"
    Then the page contains "External features of the building"
    And I should see the following within "External wall materials"
      | Material | Insulation               | Percentage |
      | Brick    | Phenolic foam insulation |     40–60% |
      | Glass    | Mineral wool             |     20–40% |
    And I should see the following within "External wall materials"
      | Material         | Percentage |
      | Total percentage |    60–100% |
    When I press "Delete" for the material "Glass"
    Then the page contains "Are you sure you want to delete the material ‘Glass’?"
    When I choose "Delete this material"
    And I press "Delete ‘Glass’"
    Then the page contains "External features of the building"
    And I should see the following within "External wall materials"
      | Material | Insulation               | Percentage |
      | Brick    | Phenolic foam insulation |     40–60% |
    And I should not see the following within "External wall materials"
      | Material | Insulation   | Percentage |
      | Glass    | Mineral wool |     20–40% |
    And I should see the following within "External wall materials"
      | Material         | Percentage |
      | Total percentage |     40–60% |

  Scenario: Alex tries to go to the next section with no materials
    Then the page contains "External features of the building"
    And the page contains "You haven’t added any materials yet."
    And the page has button "Add material"
    And the page does not have button "Save and continue"

  Scenario: Alex tries to go to the next section with not enough materials
    Given a material "Brick" that covers "40–60%" of the building and is insulated with "Phenolic foam insulation"
    Then the page contains "External features of the building"
    And I should see the following within "External wall materials"
      | Material | Insulation               | Percentage |
      | Brick    | Phenolic foam insulation |     40–60% |
    And I should see the following within "External wall materials"
      | Material         | Percentage |
      | Total percentage |     40–60% |
    And the page has button "Save and continue"
    When I press "Save and continue"
    Then the page contains an error about "The maximum total percentage should be at least 100%"

  Scenario: Alex tries to go to the next section with too many materials
    Given a material "Brick" that covers "60–80%" of the building and is insulated with "Phenolic foam insulation"
    And a material "Glass" that covers "60–80%" of the building and is insulated with "None"
    Then the page contains "External features of the building"
    And I should see the following within "External wall materials"
      | Material | Insulation               | Percentage |
      | Brick    | Phenolic foam insulation |     60–80% |
      | Glass    | None                     |     60–80% |
    And I should see the following within "External wall materials"
      | Material         | Percentage |
      | Total percentage |     120–160% |
    When I press "Save and continue"
    Then the page contains an error about "The minimum total percentage should be at most 100%"

  Scenario: Alex goes to the next section with the right amount of materials
    Given a material "Brick" that covers "40–60%" of the building and is insulated with "Phenolic foam insulation"
    And a material "Glass" that covers "40–60%" of the building and is insulated with "None"
    Then the page contains "External features of the building"
    And I should see the following within "External wall materials"
      | Material | Insulation               | Percentage |
      | Brick    | Phenolic foam insulation |     40–60% |
      | Glass    | None                     |     40–60% |
    And I should see the following within "External wall materials"
      | Material         | Percentage |
      | Total percentage |     80–120% |
    When I press "Save and continue"
    Then the page contains "External wall structures"
