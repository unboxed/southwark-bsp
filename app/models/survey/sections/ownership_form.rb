module Survey
  module Sections
    class OwnershipForm < BaseForm
      ROLES = %w[owner developer agent none other].freeze

      attribute :role, :string
      validates :role, inclusion: ROLES

      attribute :full_name, :string
      validates :full_name, presence: true, length: { maximum: 100 }

      attribute :email, :string
      validates :email, presence: true, email: { allow_blank: true }, length: { maximum: 100 }

      attribute :role_details, :string
      validates :role_details, presence: true, length: { maximum: 2000 }, if: :other_role?

      def roles
        ROLES
      end

      def other_role?
        role == "other"
      end
    end
  end
end
