require "rails_helper"

RSpec.describe BuildingExternalWallStructure, "associations" do
  it { is_expected.to belong_to :survey }
  it { is_expected.to have_one :section }
end

RSpec.describe BuildingExternalWallStructure, "#name" do
  it "returns a string descriptive of the model" do
    external_walls = build :building_external_wall_structure

    name = external_walls.name

    expect(name).to eq "External walls structures"
  end
end

RSpec.describe BuildingExternalWallStructure, "#reply" do
  it "returns the reply formatted in a readable format" do
    external_walls = build(
      :building_external_wall_structure,
      has_balconies: true,
      has_other_structure: true
    )

    reply = external_walls.reply

    expect(reply).to eq "Balconies, Other structure"
  end
end

RSpec.describe BuildingExternalWallStructure, "#should_terminate_survey?" do
  it "indicates the survey should be terminated after this section" do
    external_walls = build(
      :building_external_wall_structure,
      has_solar_shading: false,
      has_balconies: false
    )

    terminates_survey = external_walls.should_terminate_survey?

    expect(terminates_survey).to eq true
  end
end

RSpec.describe BuildingExternalWallStructure, "#complete?" do
  context "For an external wall structure with no balconies or solar shading" do
    it "indicates the section is complete if no material details are required" do
      external_walls = build(
        :building_external_wall_structure,
        has_green_walls: true
      )

      section_complete = external_walls.complete?

      expect(section_complete).to eq true
    end
  end

  context "For an external wall structure with balconies and no solar shading" do
    it "indicates the section is not complete if additional material details are required" do
      external_walls = build(
        :building_external_wall_structure,
        has_balconies: true,
        has_solar_shading: false
      )

      section_complete = external_walls.complete?

      expect(section_complete).to eq false
    end

    it "indicates the section is complete if all additional material details are present" do
      external_walls = create(
        :building_external_wall_structure,
        has_balconies: true,
        has_solar_shading: false,
      )
      create(
        :material_detail_list,
        has_concrete_primary_material: true,
        external_structure_name: "balcony",
        building_external_wall_structure: external_walls
      )

      section_complete = external_walls.complete?

      expect(section_complete).to eq true
    end
  end

  context "For an external wall structure with no balconies but with solar shading" do
    it "indicates the section is not complete if additional material details are required" do
      external_walls = build(
        :building_external_wall_structure,
        has_balconies: false,
        has_solar_shading: true
      )

      section_complete = external_walls.complete?

      expect(section_complete).to eq false
    end

    it "indicates the section is complete if all additional material details are present" do
      external_walls = create(
        :building_external_wall_structure,
        has_balconies: false,
        has_solar_shading: true
      )
      create(
        :material_detail_list,
        has_concrete_primary_material: true,
        external_structure_name: "solar_shading",
        building_external_wall_structure: external_walls
      )

      section_complete = external_walls.complete?

      expect(section_complete).to eq true
    end
  end

  context "For an external wall structure with balconies and solar shading" do
    it "indicates the section is not complete if additional material details are required" do
      external_walls = build(
        :building_external_wall_structure,
        has_balconies: true,
        has_solar_shading: true
      )

      section_complete = external_walls.complete?

      expect(section_complete).to eq false
    end

    it "indicates the section is complete if all additional material details are present" do
      external_walls = create(
        :building_external_wall_structure,
        has_balconies: true,
        has_solar_shading: true,
      )
      create(
        :material_detail_list,
        external_structure_name: "balcony",
        has_metal_primary_material: true,
        building_external_wall_structure: external_walls
      )
      create(
        :material_detail_list,
        has_concrete_primary_material: true,
        external_structure_name: "solar_shading",
        building_external_wall_structure: external_walls
      )

      section_complete = external_walls.complete?

      expect(section_complete).to eq true
    end
  end
end

RSpec.describe BuildingExternalWallStructure, "#next_required_detail" do
  context "For an external wall structure with balconies" do
    it "indicates balcony detail is required if none is present" do
      external_wall = build(
        :building_external_wall_structure,
        has_balconies: true
      )

      next_required_detail = external_wall.next_required_detail

      expect(next_required_detail).to eq :balcony
    end

    it "indicates there is no next required detail if balcony detail is present" do
      external_wall = create(
        :building_external_wall_structure,
        has_balconies: true
      )
      create(
        :material_detail_list,
        has_concrete_primary_material: true,
        external_structure_name: "balcony",
        building_external_wall_structure: external_wall
      )

      next_required_detail = external_wall.next_required_detail

      expect(next_required_detail).to eq nil
    end
  end

  context "for an external wall structure with solar shading" do
    it "indicates solar shading detail is required if none is present" do
      external_wall = build(
        :building_external_wall_structure,
        has_solar_shading: true
      )

      next_required_detail = external_wall.next_required_detail

      expect(next_required_detail).to eq :solar_shading
    end

    it "indicates there is no next required detail if solar shading detail is present" do
      external_wall = create(
        :building_external_wall_structure,
        has_solar_shading: true
      )
      create(
        :material_detail_list,
        has_concrete_primary_material: true,
        external_structure_name: "solar_shading",
        building_external_wall_structure: external_wall
      )

      next_required_detail = external_wall.next_required_detail

      expect(next_required_detail).to eq nil
    end
  end

  context "for an external wall structure with no required detail" do
    it "indicates there is no next required detail" do
      external_wall = build(
        :building_external_wall_structure,
        has_green_walls: true
      )

      next_required_detail = external_wall.next_required_detail

      expect(next_required_detail).to eq nil
    end
  end
end

RSpec.describe BuildingExternalWallStructure, "validation" do
  it "displays an error if no options for external walls are selected" do
    survey = create :survey
    building_wall_structure = BuildingExternalWallStructure.new(survey: survey)

    expect(building_wall_structure).to be_invalid
    expect(building_wall_structure.errors[:external_structures]).to include("Please select at least one option")
  end
end
