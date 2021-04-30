require "rails_helper"

RSpec.describe DeltaCsvMapper do
  let!(:building) { create(:building) }
  let!(:survey) { create(:survey, :completed, building: building) }

  subject { building }

  describe "unknown values", focus: true do
    describe "for material" do
      before do
        building.survey.materials = [{ "type" => "unknown" }]
      end

      it "returns donotknow" do
        expect(building.csv_material_1).to eq "donotknow"
      end
    end

    describe "for insulation" do
      before do
        building.survey.materials = [{ "insulation" => "unknown" }]
      end

      it "returns do not know" do
        expect(building.csv_insulation_1).to eq "do not know"
      end
    end

    describe "for balconies/solar shading" do
      before do
        building.survey.balcony_floor_materials   = ["unknown"]
        building.survey.balcony_main_material     = "unknown"
        building.survey.balcony_railing_materials = ["unknown"]
        building.survey.balcony_floor_materials   = ["unknown"]
        building.survey.solar_shading_materials = ["unknown"]
      end

      %w[
        balconies_material_floor
        balconies_material_structure
        balconies_material_balustrade
        balconies_material_floor
        solarshading_materials
      ].each do |attr|
        it "returns do-not-know for #{attr}" do
          value = building.send "csv_#{attr}"

          if value.is_a? Array
            expect(value).to eq ["do-not-know"]
          else
            expect(value).to eq "do-not-know"
          end
        end
      end
    end
  end
end
