require "rails_helper"

RSpec.describe Building, "associations" do
  it { is_expected.to have_one :survey }
end

RSpec.describe Building, "validations" do
  it { is_expected.to validate_uniqueness_of :uprn }
end

RSpec.describe Building, ".ordered_by_uprn" do
  it "returns the buildings ordered by ascending UPRN" do
    create :building, uprn: "10012"
    create :building, uprn: "10008"

    ordered = Building.ordered_by_uprn

    expect(ordered.map(&:uprn)).to eq ["10008", "10012"]
  end
end
