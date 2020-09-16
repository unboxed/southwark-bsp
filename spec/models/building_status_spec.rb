require "rails_helper"

RSpec.describe BuildingStatus, "associations" do
  it { is_expected.to belong_to :survey }
  it { is_expected.to have_one :section }
end

RSpec.describe BuildingStatus, "#name" do
  it "returns a string descriptive of the model" do
    building_status = BuildingStatus.new

    name = building_status.name

    expect(name).to eq "Building status"
  end
end

RSpec.describe BuildingStatus, "#reply" do
  it "returns a humanized form of the status" do
    building_status = BuildingStatus.new status: "existing"

    reply = building_status.reply

    expect(reply).to eq "Existing"
  end
end

RSpec.describe BuildingStatus, "#should_terminate_survey?" do
  it "returns true if the building status isn't 'existing'" do
    building_status = BuildingStatus.new status: "demolished"

    terminates_survey = building_status.should_terminate_survey?

    expect(terminates_survey).to eq true
  end

  it "returns false if the building status is 'existing'" do
    building_status = BuildingStatus.new status: "existing"

    terminates_survey = building_status.should_terminate_survey?

    expect(terminates_survey).to eq false
  end
end

RSpec.describe BuildingStatus, "validation" do
  it "throws an error if status is not present" do
    building_status = BuildingStatus.new status: ""

    expect(building_status).not_to be_valid
    expect(building_status.errors.added?(:status, "can't be blank. Please select one value from the list")).to be_truthy
  end
end
