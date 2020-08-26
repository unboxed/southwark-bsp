require "rails_helper"

RSpec.describe Section, "associations" do
  it { is_expected.to belong_to :content }
  it { is_expected.to belong_to :survey }
end

RSpec.describe Section, "delegated methods" do
  it { is_expected.to delegate_method(:name).to :content }
  it { is_expected.to delegate_method(:reply).to :content }
  it { is_expected.to delegate_method(:should_terminate_survey?).to :content }
end
