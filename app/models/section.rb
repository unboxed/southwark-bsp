class Section < ApplicationRecord
  belongs_to :content, polymorphic: true
  belongs_to :survey

  delegate :name, :reply, :should_terminate_survey?, to: :content

  def to_partial_path
    content.to_partial_path
  end
end
