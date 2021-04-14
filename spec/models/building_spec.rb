require "rails_helper"

RSpec.describe Building do
  subject { create(:building) }

  describe "validation" do
    it "has a valid factory" do
      expect(build(:building)).to be_valid
    end
  end

  it "is not valid without a UPRN" do
    expect(build(:building, uprn: nil)).to_not be_valid
  end

  describe "surveys" do
    it "has many surveys" do
      expect { create(:survey, building: subject) }
        .to change { subject.surveys.count }.from(0).to(1)
    end

    it "has a latest survey" do
      old_survey = create(:survey, building: subject, completed_at: 3.days.ago)

      expect(subject.latest_survey).to eq old_survey

      new_survey = create(:survey, building: subject, completed_at: Time.zone.now)

      expect(subject.latest_survey).to eq new_survey
    end
  end
end
