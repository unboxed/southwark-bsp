require 'rails_helper'

RSpec.describe "Help page" do
  it "has a clickable help link" do
    visit root_path
    click_on "Help"
    expect(page).to have_content "Contact Southwark Council at buildingsafety@southwark.gov.uk if you have questions about the information required in the Building Safety Survey."
  end
end
