require "rails_helper"

RSpec.describe BuildingExternalWallStructure, "associations" do
  it { is_expected.to belong_to :survey }
  it { is_expected.to have_one :section }
end

RSpec.describe BuildingExternalWallStructure, "#name" do
  it "returns a string descriptive of the model" do
    external_walls = BuildingExternalWallStructure.new

    name = external_walls.name

    expect(name).to eq "External walls structures"
  end
end

RSpec.describe BuildingExternalWallStructure, "#reply" do
  it "returns the reply formatted in a readable format" do
    external_walls = BuildingExternalWallStructure.new has_balconies: true, has_other_structure: true

    reply = external_walls.reply

    expect(reply).to eq "Balconies, Other structure"
  end
end

RSpec.describe BuildingExternalWallStructure, "#should_terminate_survey?" do
  it "indicates the survey should be terminated after this section" do
    external_walls = BuildingExternalWallStructure.new

    terminates_survey = external_walls.should_terminate_survey?

    expect(terminates_survey).to eq true
  end
end
