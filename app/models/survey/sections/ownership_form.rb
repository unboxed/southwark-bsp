module Survey
  module Sections
    class OwnershipForm < BaseForm
      ROLES = %w[owner developer agent other none]

      attribute :role, :string
      validates :role, inclusion: ROLES

      attribute :right_to_manage_company, :boolean
      validates :right_to_manage_company, inclusion: [true, false]

      attribute :full_name, :string
      validates :full_name, presence: true, length: { maximum: 100 }

      attribute :email, :string
      validates :email, presence: true, email: { allow_blank: true }, length: { maximum: 100 }

      attribute :organisation, :string
      validates :organisation, presence: true, length: { maximum: 100 }

      attribute :ownership_details, :string
      validates :ownership_details, length: { maximum: 2000 }

      def roles
        ROLES
      end
    end
  end
end
