module Survey
  module Sections
    class BuildingManagementForm < BaseForm
      attribute :is_right_to_manage, :string
      validates :is_right_to_manage, presence: true

      attribute :right_to_manage_company, :string
      validates :right_to_manage_company, presence: true, length: { maximum: 100 }, if: :right_to_manage?

      attribute :building_owner, :string
      validates :building_owner, length: { maximum: 100 }

      attribute :building_developer, :string
      validates :building_developer, length: { maximum: 100 }

      attribute :managing_agent, :string
      validates :managing_agent, length: { maximum: 100 }

      def right_to_manage?
        is_right_to_manage == "true"
      end
    end
  end
end
