FactoryBot.define do
  factory :building do
    association :manager, factory: :building_manager

    building_name { "A place full of wonders" }
    street { "1 Union Street" }
    city_town { "London" }
    postcode { "NW1235" }
    uprn { SecureRandom.alphanumeric }
  end
end
