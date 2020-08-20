FactoryBot.define do
  factory :building_manager do
    sequence(:email) { |i| "beans#{i}@example.com" }
  end
end
