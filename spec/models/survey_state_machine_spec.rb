require "rails_helper"

RSpec.describe SurveyStateMachine do
  let!(:building) { FactoryBot.create(:building) }
  let!(:survey) { FactoryBot.create(:survey, building: building) }

  subject { building.survey_state }

  it "is initially in not_contacted state" do
    expect(subject).to be_in_state "not_contacted"
  end

  it "has the correct transition records setup" do
    subject.transition_to! :contacted

    expect(subject.last_transition).to_not be_nil
  end

  context "when the survey is completed" do
    before do
      survey.update!(completed_at: Time.zone.now)
    end

    it "moves to received" do
      expect(subject).to be_in_state "received"
    end

    context "when the survey is rejected" do
      before do
        building.survey_state.transition_to! :rejected
      end

      it "can receive a new survey to move back to received" do
        create(:survey, :completed, building: building)

        expect(subject).to be_in_state "received"
      end
    end
  end
end
