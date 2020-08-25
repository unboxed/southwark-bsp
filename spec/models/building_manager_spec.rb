require "rails_helper"

RSpec.describe BuildingManager, "associations" do
  it { is_expected.to have_many :buildings }
end
