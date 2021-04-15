FactoryBot.define do
  factory :building do
    building_name { Faker::Company.name }
    street { Faker::Address.street_name }
    city_town { Faker::Address.city }
    postcode { Faker::Address.postcode }
    uprn { Faker::Number.number(digits: 12) }
  end
end
