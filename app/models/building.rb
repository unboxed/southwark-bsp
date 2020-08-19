class Building < ApplicationRecord
  belongs_to :manager, class_name: "BuildingManager"

  def manager_email_address
    manager.email
  end
end
