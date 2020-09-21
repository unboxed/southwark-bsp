require "rails_helper"

RSpec.describe BuildingHeight, "associations" do
  it { is_expected.to belong_to :survey }
  it { is_expected.to have_one :section }
end

RSpec.describe BuildingHeight, "#name" do
  it "returns a string description of the model" do
    building_height = BuildingHeight.new

    name = building_height.name

    expect(name).to eq "Building height"
  end
end

RSpec.describe BuildingHeight, "#reply" do
  context "for a building taller than 18 meters" do
    it "returns a humanized form of the building height" do
      building_height = BuildingHeight.new higher_than_18_meters: true, height_in_storeys: 10, height_in_meters: 22

      reply = building_height.reply

      expect(reply).to eq "Taller than 18 meters - 22 meters  10 storey(s)"
    end
  end

  context "for a building under 18 meters tall" do
    it "returns a humanized form of the building height" do
      building_height = BuildingHeight.new higher_than_18_meters: false, height_in_storeys: 1, height_in_meters: 9

      reply = building_height.reply

      expect(reply).to eq "Under 18 meters tall - 9 meters  1 storey(s)"
    end
  end
end

RSpec.describe BuildingHeight, "#should_terminate_survey?" do
  it "returns true if the building is under 18 meters tall" do
    building_height = BuildingHeight.new higher_than_18_meters: false

    terminates_survey = building_height.should_terminate_survey?

    expect(terminates_survey).to eq true
  end

  it "returns false if the building is taller than 18 meters" do
    building_height = BuildingHeight.new higher_than_18_meters: true

    terminates_survey = building_height.should_terminate_survey?

    expect(terminates_survey).to eq false
  end
end
