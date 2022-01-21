require "rails_helper"
require "csv"

MOCK_NOT_CONTACTED_BUILDING_ATTRIBUTES = {
  building_name: "Some building",
  street: "Some street",
  city_town: "Some town",
  postcode: "Some postcode",
  uprn: 1_234_567_890,
  land_registry_proprietor_address: "4 Union Street, London SE1 4QX",
  land_registry_proprietor_name: "Proprietor person"
}.freeze

MOCK_CONTACTED_BUILDING_ATTRIBUTES = {
  building_name: "Some building 1",
  street: "Some street 1",
  city_town: "Some town 1",
  postcode: "Some postcode 1",
  uprn: 1_234_567_891,
  proprietor_email: "email1@example.com",
  land_registry_proprietor_address: "5 Union Street, London SE1 4QX",
  land_registry_proprietor_name: "Proprietor person"
}.freeze

MOCK_REJECTED_BUILDING_ATTRIBUTES = {
  building_name: "Some building 2",
  street: "Some street 2",
  city_town: "Some town 2",
  postcode: "Some postcode 2",
  uprn: 1_234_567_892,
  proprietor_email: "email2@example.com",
  land_registry_proprietor_address: "6 Union Street, London SE1 4QX",
  land_registry_proprietor_name: "Proprietor person"
}.freeze

MOCK_REJECTED_SURVEY_ATTRIBUTES = {
  "stage" => "rejected",
  "data" =>
  { "role" => "owner",
    "uprn" => "1234567890",
    "email" => "steph@steph.com",
    "usage" => "private_housing",
    "material" => nil,
    "completed" => true,
    "full_name" => "Steph",
    "materials" =>
   [{ "id" => "76a8a9f2",
      "type" => "glass",
      "details" => "The glass details",
      "coverage" => 50,
      "insulation" => "wool",
      "other_type" => nil,
      "other_insulation" => "",
      "insulation_details" => "Details about the glass insulation" }] },
  "submitted_at" => nil,
  "created_at" => "Wed, 28 Apr 2021 18:02:45.232569000 UTC +00:00",
  "updated_at" => "Wed, 28 Apr 2021 18:16:36.174965000 UTC +00:00",
  "next_stage" => nil
}.freeze

MOCK_ACCEPTED_BUILDING_ATTRIBUTES = {
  building_name: "Some building 3",
  street: "Some street 3",
  city_town: "Some town 3",
  postcode: "Some postcode 3",
  uprn: 1_234_567_893,
  proprietor_email: "email3@example.com",
  land_registry_proprietor_address: "7 Union Street, London SE1 4QX",
  land_registry_proprietor_name: "Proprietor person"
}.freeze

MOCK_ACCEPTED_SURVEY_ATTRIBUTES = {
  "stage" => "complete",
  "data" =>
  { "role" => "owner",
    "uprn" => "1234567890",
    "email" => "steph@steph.com",
    "usage" => "private_housing",
    "material" => nil,
    "completed" => true,
    "full_name" => "Steph",
    "materials" =>
   [{ "id" => "76a8a9f2",
      "type" => "glass",
      "details" => "The glass details",
      "coverage" => 50,
      "insulation" => "wool",
      "other_type" => nil,
      "other_insulation" => "",
      "insulation_details" => "Details about the glass insulation" },
    { "id" => "ca5efcfb",
      "type" => "unknown",
      "details" => "Details about unknown",
      "coverage" => 30,
      "insulation" => "unknown",
      "other_type" => nil,
      "other_insulation" => "",
      "insulation_details" => "Unknown insulation details" },
    { "id" => "52d73867",
      "type" => "other",
      "details" => "Details about other",
      "coverage" => 30,
      "insulation" => "other",
      "other_type" => "Other material",
      "other_insulation" => "Other insulation",
      "insulation_details" => "Details about other insulation" }],
    "structures" => ["balconies", "solar_shading", "green_walls", "other"],
    "building_owner" => "Owner person",
    "managing_agent" => "Managing person",
    "height_in_metres" => 70.0,
    "number_of_storeys" => 8,
    "building_developer" => "Developer person",
    "is_right_to_manage" => "no",
    "structures_details" => "Some other structures",
    "has_residential_use" => true,
    "balcony_main_material" => "timber_or_wood",
    "balcony_floor_materials" => ["glass", "metal", "other"],
    "right_to_manage_company" => "",
    "solar_shading_materials" => ["concrete", "other"],
    "balcony_railing_materials" => ["glass", "other"],
    "balcony_main_material_details" => "",
    "balcony_floor_materials_details" => "Other balcony floor materials",
    "solar_shading_materials_details" => "Other solar shading materials",
    "balcony_railing_materials_details" => "Other balustrade materials" },
  "submitted_at" => nil,
  "created_at" => "Wed, 28 Apr 2021 18:02:45.232569000 UTC +00:00",
  "updated_at" => "Wed, 28 Apr 2021 18:16:36.174965000 UTC +00:00",
  "next_stage" => nil
}.freeze

RSpec.describe BuildingExporter do
  let!(:not_contacted_building) { FactoryBot.create(:building, MOCK_NOT_CONTACTED_BUILDING_ATTRIBUTES) }

  let!(:contacted_building) { FactoryBot.create(:building, MOCK_CONTACTED_BUILDING_ATTRIBUTES) }
  let!(:contacted_notification) do
    FactoryBot.create(:notification, building: contacted_building, notification_mean: "letter", sent_at: "2022-01-20 16:15:07.433371 +0000")
  end

  let!(:rejected_building) { FactoryBot.create(:building, MOCK_REJECTED_BUILDING_ATTRIBUTES) }
  let!(:rejected_survey) { FactoryBot.create(:survey, building: rejected_building, **MOCK_REJECTED_SURVEY_ATTRIBUTES) }
  let!(:rejected_notification) do
    FactoryBot.create(:notification, building: rejected_building, notification_mean: "letter", sent_at: "2022-01-19 16:15:07.433371 +0000")
  end

  let!(:accepted_building) { FactoryBot.create(:building, MOCK_ACCEPTED_BUILDING_ATTRIBUTES) }
  let!(:accepted_survey) { FactoryBot.create(:survey, building: accepted_building, **MOCK_ACCEPTED_SURVEY_ATTRIBUTES) }
  let!(:accepted_notification) do
    FactoryBot.create(:notification, building: accepted_building, notification_mean: "letter", sent_at: "2022-01-18 16:15:07.433371 +0000")
  end

  path = File.expand_path("#{File.dirname(__FILE__)}/building_csv_mock.csv")

  describe "mapping" do
    before do
      travel_to Time.zone.local(2022, 1, 21) do
        contacted_building.survey_state.transition_to! :contacted

        rejected_survey.update!(completed_at: Faker::Time.between(from: 1.year.ago, to: Time.zone.now))
        rejected_survey.reject!

        accepted_survey.update!(completed_at: Faker::Time.between(from: 1.year.ago, to: Time.zone.now))
        accepted_survey.accept!
      end
    end

    context "For a building that has not been contacted" do
      expected = CSV.parse(File.read(path), headers: true).first
      expected.each do |attr, value|
        it "correctly maps the '#{attr}' field" do
          raw = BuildingExporter.render.to_a.join("\n")
          result = CSV.parse(raw, headers: true)[1]

          expect(result[attr]).to eq value
        end
      end
    end

    context "For a building that has been contacted" do
      expected = CSV.parse(File.read(path), headers: true)[1]
      expected.each do |attr, value|
        it "correctly maps the '#{attr}' field" do
          raw = BuildingExporter.render.to_a.join("\n")
          result = CSV.parse(raw, headers: true)[3]

          expect(result[attr]).to eq value
        end
      end
    end

    context "For a building with a survey that has been rejected" do
      expected = CSV.parse(File.read(path), headers: true)[2]
      expected.each do |attr, value|
        it "correctly maps the '#{attr}' field" do
          raw = BuildingExporter.render.to_a.join("\n")
          result = CSV.parse(raw, headers: true)[5]

          expect(result[attr]).to eq value
        end
      end
    end

    context "For a building with a survey that has been accepted" do
      expected = CSV.parse(File.read(path), headers: true)[3]
      expected.each do |attr, value|
        it "correctly maps the '#{attr}' field" do
          raw = BuildingExporter.render.to_a.join("\n")
          result = CSV.parse(raw, headers: true)[7]

          expect(result[attr]).to eq value
        end
      end
    end
  end
end
