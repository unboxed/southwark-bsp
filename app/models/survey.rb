class Survey < ApplicationRecord
  belongs_to :building
  has_many :sections
  before_create :set_reference

  private

    def set_reference
      self.reference_id = SecureRandom.hex(12).upcase
    end
end
