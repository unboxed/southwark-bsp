require "rails_helper"

RSpec.describe Survey, "associations" do
  it { is_expected.to belong_to :building }
  it { is_expected.to have_many :sections }
end

RSpec.describe Survey, ".most_recently_answered_question" do
  it "returns the most recently filled in section" do
    survey = create :survey
    ownership = create(
      :building_ownership,
      ownership_status: "building_developer",
      survey: survey
    )
    section = create :section, survey: survey, content: ownership

    most_recent_answer = survey.most_recently_answered_question

    expect(most_recent_answer).to eq section
  end
end
