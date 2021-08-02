FactoryBot.define do
  factory :survey, class: "Survey::Record" do
    session_id { SecureRandom.hex }

    building

    stage { "uprn" }

    uprn { building.uprn }
    structures { %w[balconies solar_shading] }

    completed { stage == "check_your_answers" }

    trait :residential_use do
      has_residential_use { true }
      usage { Survey::Sections::ResidentialUseForm::USES.sample }
    end

    trait :completed do
      completed { true }
      completed_at { Faker::Time.between(from: 1.year.ago, to: Time.zone.now) }
    end

    trait :not_contacted

    trait :contacted do
      after(:create) do |survey|
        survey.building.send_letter!
      end
    end

    trait :received do
      after(:create) do |survey|
        survey.update!(completed_at: Faker::Time.between(from: 1.year.ago, to: Time.zone.now))
      end
    end

    trait :rejected do
      received

      after(:create, &:reject!)
    end

    trait :accepted do
      received

      after(:create, &:accept!)
    end
  end
end
