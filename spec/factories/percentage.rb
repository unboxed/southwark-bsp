FactoryBot.define do
  factory :percentage do
    association :material

    material_percentage { 50 }
  end
end
