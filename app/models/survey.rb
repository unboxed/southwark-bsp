class Survey < ApplicationRecord
  belongs_to :building
  has_many :sections

  def most_recently_answered_question
    sections.most_recently_answered.first
  end
end
