class SurveyStateMachine
  include Statesman::Machine

  state :not_contacted, initial: true
  state :contacted
  state :received
  state :rejected
  state :accepted
  state :exported

  transition from: :not_contacted, to: %i[contacted received]
  transition from: :contacted,     to: %i[received]
  transition from: :received,      to: %i[accepted rejected]
  transition from: :accepted,      to: %i[rejected]
  transition from: :rejected,      to: %i[accepted received]
end
