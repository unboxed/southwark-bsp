FactoryBot.define do
  factory :insulation do
    association :material

    insulations = [
      "Polyurethane rigid foam (PUR) or Polyisocyanurate foam (PIR)",
      "Phenolic foam insulation",
      "Expanded and Extruded polystyrene (EPS/XPS)",
      "Glass wool", "Wood fibre", "Mineral wool",
      "None", "Do not know", "Other"
    ]
    insulation_material { insulations.sample }
  end
end
