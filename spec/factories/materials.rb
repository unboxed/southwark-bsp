FactoryBot.define do
  factory :material do
    association :building_wall
    materials = [
      "Glass", "High pressure laminate",
      "Aluminium composite material", "Other metal composite material",
      "Metal sheet panels", "Render system",
      "Brick slips", "Brick", "Stone panels or stone",
      "Tilling systems", "Timber or wood",
      "Plastic"
    ]
    name { materials.sample }
    comments { "potato" }
  end
end
