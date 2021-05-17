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
      completed_at { Faker::Time.between(from: 1.year.ago, to: Time.zone.now) }
    end
  end

  factory :contacted_survey, parent: :survey do
    after(:create) do |survey|
      survey.building.send_letter!
    end
  end

  factory :received_survey, parent: :contacted_survey do
    after(:create) do |survey|
      survey.update!(completed_at: Faker::Time.between(from: 1.year.ago, to: Time.zone.now))
    end
  end

  factory :accepted_survey, parent: :received_survey do
    after(:create, &:accept!)
  end

  factory :rejected_survey, parent: :received_survey do
    after(:create, &:reject!)
  end
end
