require "rails_helper"
require "csv"

MOCK_BUILDING_ATTRIBUTES = {
  building_name: "Some building",
  street: "Some street",
  city_town: "Some town",
  postcode: "Some postcode",
  uprn: 1_234_567_890,
  proprietor_email: "email@example.com",
  land_registry_proprietor_address: "4 Union Street, London SE1 4QX",
  land_registry_proprietor_name: "Proprietor person"
}.freeze

MOCK_SURVEY_ATTRIBUTES = {
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
  "completed_at" => "Wed, 28 Apr 2021 18:16:36.160125000 UTC +00:00",
  "submitted_at" => nil,
  "created_at" => "Wed, 28 Apr 2021 18:02:45.232569000 UTC +00:00",
  "updated_at" => "Wed, 28 Apr 2021 18:16:36.174965000 UTC +00:00",
  "next_stage" => nil
}.freeze

RSpec.describe DeltaExporter do
  let!(:building) { FactoryBot.create(:building, MOCK_BUILDING_ATTRIBUTES) }
  let!(:survey) { FactoryBot.create(:accepted_survey, building: building, **MOCK_SURVEY_ATTRIBUTES) }

  path = File.expand_path("#{File.dirname(__FILE__)}/delta_csv_mock.csv")
  expected = CSV.parse(File.read(path), headers: true).first

  describe "mapping" do
    expected.each do |attr, value|
      it "correctly maps the `#{attr}' field" do
        raw = DeltaExporter.render(Building.search(uprn: building.uprn)).to_a.join("\n")
        result = CSV.parse(raw, headers: true)[1]

        expect(result[attr]).to eq value
      end
    end
  end

  it "does not include incomplete surveys" do
    incomplete_survey = FactoryBot.create(:survey, :completed)

    raw = DeltaExporter.render.to_a.join("\n")

    expect(raw).to_not include incomplete_survey.uprn
  end

  it "orders the surveys by completion date" do
    one = FactoryBot.create(:survey, :completed, completed_at: 3.days.ago)
    two = FactoryBot.create(:survey, :completed, completed_at: 10.days.ago)
    three = FactoryBot.create(:survey, :completed, completed_at: 2.hours.ago)

    [one, two, three].each(&:accept!)

    expected_order = [two, one, three, survey].map { |r| r.building.uprn }

    raw = DeltaExporter.render.to_a.join

    result = CSV.parse(raw, headers: true)

    expect(result.map { |r| r["UPRN"] }).to eq expected_order
  end
end
