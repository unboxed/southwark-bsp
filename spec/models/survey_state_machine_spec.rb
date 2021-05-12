require "rails_helper"

RSpec.describe SurveyStateMachine do
  let!(:building) { FactoryBot.create(:building) }
  let!(:survey) { FactoryBot.create(:survey, building: building) }

  subject { building.survey_state }

  it "is initially in not_contacted state" do
    expect(subject.current_state).to eq "not_contacted"
  end

  it "has the correct transition records setup" do
    subject.transition_to! :contacted

    expect(subject.last_transition).to_not be_nil
  end

  context "when the survey is completed" do
    before do
      survey.update!(completed: true)
    end

    it "moves to received" do
      expect(subject.current_state).to eq "received"
    end
  end
end
