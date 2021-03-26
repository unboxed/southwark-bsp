FactoryBot.define do
  factory :building do
    building_name { "A place full of wonders" }
    street { "1 Union Street" }
    city_town { "London" }
    postcode { "NW1235" }
    uprn { SecureRandom.rand(100000000) + 10000000000 }
  end
end
