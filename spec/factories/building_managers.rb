FactoryBot.define do
  factory :building_manager do
    sequence(:email) { |n| "example_manager_#{n}@example.com" }
  end
end
