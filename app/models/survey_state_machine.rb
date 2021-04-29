class SurveyStateMachine
  include Statesman::Machine

  state :not_contacted, initial: true
  state :contacted

  transition from: :not_contacted, to: [:contacted]
end
