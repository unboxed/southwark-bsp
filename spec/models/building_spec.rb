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

    it "destroys its surveys" do
      create_list(:survey, 3, building: subject)

      expect { subject.destroy! }.to change { Survey::Record.count }.by(-3)
    end
  end
end
