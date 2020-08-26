require "rails_helper"

RSpec.describe BuildingTenure, "associations" do
  it { is_expected.to belong_to :survey }
  it { is_expected.to have_one :section }
end

RSpec.describe BuildingTenure, "#name" do
  it "returns a string descriptive of the model" do
    building_tenure = BuildingTenure.new

    name = building_tenure.name

    expect(name).to eq "Building tenure"
  end
end

RSpec.describe BuildingTenure, "#reply" do
  it "returns a humanized form of the status" do
    building_tenure = BuildingTenure.new tenure_type: "student_accomodation"

    reply = building_tenure.reply

    expect(reply).to eq "Student accomodation"
  end
end

RSpec.describe BuildingTenure, "#should_terminate_survey?" do
  it "returns false" do
    building_tenure = BuildingTenure.new

    terminates_survey = building_tenure.should_terminate_survey?

    expect(terminates_survey).to eq false
  end
end
