require "rails_helper"

RSpec.describe "Admin manages survey state" do
  include SignInHelpers

  it "indicates if a survey is not yet started" do
    create :building, survey: nil

    sign_in_as_admin

    expect(page).to have_content "Not started"
  end

  it "indicates a survey has been started" do
    create :building, survey: create(:survey)

    sign_in_as_admin

    expect(page).to have_content "Started on #{Date.today}"
  end

  it "indicates the latest survey section filled" do
    survey = create(:survey)
    create :building, survey: survey
    ownership = create(
      :building_ownership,
      ownership_status: "building_developer",
      survey: survey
    )
    create :section, survey: survey, content: ownership

    sign_in_as_admin

    expect(page).to have_content "Most recent answer: Building ownership"

    click_link "View summary"
  end
end
