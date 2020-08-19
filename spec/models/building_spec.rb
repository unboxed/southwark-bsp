require 'rails_helper'

RSpec.describe Building, "#manager_email_address" do
  it "returns the email address of the building manager" do
    manager = FactoryBot.build :building_manager, email: "manager@example.com"
    building = FactoryBot.build :building, manager: manager

    manager_email = building.manager_email_address

    expect(manager_email).to eq "manager@example.com"
  end
end
