require "rails_helper"

RSpec.describe Survey, "associations" do
  it { is_expected.to belong_to :building }
  it { is_expected.to have_many :sections }
end
