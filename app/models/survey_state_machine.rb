class SurveyStateMachine
  include Statesman::Machine

  state :not_contacted, initial: true
  state :contacted
  state :received
  state :rejected
  state :accepted
  state :exported

  transition from: :not_contacted, to: [:contacted, :received]
  transition from: :received, to: [:accepted, :rejected]
  transition from: :accepted, to: [:rejected]
  transition from: :rejected, to: [:accepted]
end
