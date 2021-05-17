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

  describe "facets" do
    describe ":accepted" do
      it "only grabs buildings with accepted surveys" do
        survey = create(:survey, :completed)

        expect(Building.search(state: "accepted")).to_not include survey
      end

      it "orders surveys by time of acceptance" do
        old = FactoryBot.create(:survey, completed_at: 2.hours.ago)
        older = FactoryBot.create(:survey, completed_at: 3.days.ago)
        oldest = FactoryBot.create(:survey, completed_at: 10.days.ago)

        [old, older, oldest].each do |survey|
          Timecop.freeze(survey.completed_at) do
            survey.accept!
          end
        end

        expected_order = [old, older, oldest].map { |s| s.building.uprn }

        expect(Building.search(state: "accepted").map(&:uprn)).to eq expected_order
      end
    end
  end
end
