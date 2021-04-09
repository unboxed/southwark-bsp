FactoryBot.define do
  factory :survey, class: "Survey::Record" do
    session_id { SecureRandom.hex }

    building

    stage { "uprn" }

    uprn { building.uprn }
    structures { %w[balconies solar_shading] }

    completed { stage == "check_your_answers" }
  end
end
