require "rails_helper"

RSpec.describe MaterialDetailList, "associations" do
  it { is_expected.to belong_to :building_external_wall_structure }
end

RSpec.describe MaterialDetailList, "validations" do
  it { is_expected.to validate_presence_of :external_structure_name }
  it { is_expected.to validate_inclusion_of(:external_structure_name).in_array %w(balcony solar_shading) }
end
