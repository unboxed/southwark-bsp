FactoryBot.define do
  factory :building do
    building_name { Faker::Company.name }
    street { Faker::Address.street_name }
    city_town { Faker::Address.city }
    postcode { Faker::Address.postcode }
    uprn { Faker::Number.number(digits: 12) }
    proprietor_email { "fake@example.com" }
    land_registry_proprietor_address { "4 Union Street, London SE1 4QX" }
    land_registry_proprietor_name { Faker::Name.name }

    trait :not_contacted

    trait :contacted do
      after(:create) do |building|
        building.survey_state.transition_to! :contacted
      end
    end

    trait :received do
      after(:create) do |building|
        building.survey_state.transition_to! :received
      end
    end

    trait :rejected do
      received

      after(:create) do |building|
        building.survey_state.transition_to! :rejected
      end
    end

    trait :accepted do
      received

      after(:create) do |building|
        building.survey_state.transition_to! :accepted
      end
    end
  end
end
