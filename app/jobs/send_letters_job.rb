class SendLettersJob < ApplicationJob
  queue_as :default

  def perform(ids)
    Building.send_letters!(ids)
  end
end
