class AddOtherRelationshipToBuildingOwner < ActiveRecord::Migration[6.0]
  def change
    add_column :building_ownerships, :has_other_relationship, :boolean, null: false, default: false
    add_column :building_ownerships, :has_other_relationship_details, :string
  end
end
