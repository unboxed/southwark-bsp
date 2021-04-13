FactoryBot.define do
  factory :building do
    building_name { Faker::Company.name }
    street { Faker::Address.street_name }
    city_town { Faker::Address.city }
    postcode { Faker::Address.postcode }
    uprn { Faker::Number.number(digits: 12) }
    proprietor_email { "fake@example.com" }
    land_registry_proprietor_address { "4 Union Street, London SE1 4QX" }
    land_registry_proprietor_name  { Faker::Name.name }
  end
end
