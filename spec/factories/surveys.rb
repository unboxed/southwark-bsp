FactoryBot.define do
  factory :survey, class: "Survey::Record" do
    session_id { SecureRandom.hex }

    building

    stage { "uprn" }

    uprn { building.uprn }
    structures { %w[balconies solar_shading] }

    completed { stage == "check_your_answers" }

    trait :completed do
      completed { true }
      completed_at { Time.zone.now }
    end
  end

  factory :accepted_survey, parent: :survey do
    after(:create, &:accept!)
  end
end
