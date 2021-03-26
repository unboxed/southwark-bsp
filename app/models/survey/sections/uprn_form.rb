module Survey
  module Sections
    class UprnForm < BaseForm
      attribute :uprn, :string
      validates :uprn, presence: true

      before_validation do
        if uprn.present?
          record.building = Building.find_by(uprn: uprn)
        end
      end
    end
  end
end
