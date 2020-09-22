require "rails_helper"

RSpec.describe Material, "validation" do
  it "is invalid if comments are not provided" do
    material = Material.create(name: "Brick", building_wall_id: 1, comments: "")


    expect(material).not_to be_valid
    expect(material.errors.added?(:comments, "can't be blank")).to be_truthy
  end
end
