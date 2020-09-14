require "rails_helper"

RSpec.describe BuildingOwnership, "associations" do
  it { is_expected.to belong_to :survey }
  it { is_expected.to have_one :section }
end

RSpec.describe BuildingOwnership, "#name" do
  it "returns a string descriptive of the model" do
    building_ownership = BuildingOwnership.new

    name = building_ownership.name

    expect(name).to eq "Building ownership"
  end
end

RSpec.describe BuildingOwnership, "#reply" do
  it "returns a humanized form of the status" do
    building_ownership = BuildingOwnership.new ownership_status: "building_owner_freeholder"

    reply = building_ownership.reply

    expect(reply).to eq "Building owner freeholder details:none   "
  end
end

RSpec.describe BuildingOwnership, "#should_terminate_survey?" do
  it "returns true if the building ownership_status is 'i_am_not_associated_with_this_building'" do
    building_ownership = building_ownership = BuildingOwnership.new ownership_status: "i_am_not_associated_with_this_building"

    terminates_survey = building_ownership.should_terminate_survey?

    expect(terminates_survey).to eq true
  end

  it "returns false if the building status is not 'i_am_not_associated_with_this_building'" do
    building_ownership = building_ownership = BuildingOwnership.new ownership_status: "building_owner_freeholder"

    terminates_survey = building_ownership.should_terminate_survey?

    expect(terminates_survey).to eq false
  end
end
