FactoryBot.define do
  factory :notification do
    building { nil }

    trait :email do
      notification_mean { "email" }
    end

    trait :letter do
      notification_mean { "letter" }
    end

    factory :email_notification, traits: [:email]
    factory :letter_notification, traits: [:letter]
  end
end
