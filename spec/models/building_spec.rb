require "rails_helper"

RSpec.describe Building, "associations" do
  it { is_expected.to have_one :survey }
end
