class Section < ApplicationRecord
  belongs_to :content, polymorphic: true
  belongs_to :survey

  delegate :name, :reply, :should_terminate_survey?, to: :content
end
