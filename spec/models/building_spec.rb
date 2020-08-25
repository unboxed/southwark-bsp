require "rails_helper"

RSpec.describe Building, "associations" do
  it { is_expected.to belong_to(:manager).class_name("BuildingManager") }
  it { is_expected.to have_one :survey }
end
