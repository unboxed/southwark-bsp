FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "southwark_admin_#{n}@example.com" }
    password { "verySecure" }
  end
end
