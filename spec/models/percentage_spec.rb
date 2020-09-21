require "rails_helper"

RSpec.describe BuildingStatus, "validation" do
    it "is invalid if material_percentage is not present" do
      percentage = Percentage.create(material_id: 1, material_percentage: "")


      expect(percentage).not_to be_valid
      expect(percentage.errors.added?(:material_percentage, "can't be blank")).to be_truthy
    end
  end
