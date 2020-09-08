FactoryBot.define do
  factory :building do
    association :manager, factory: :building_manager

    address { "A place full of wonders" }
    uprn { SecureRandom.alphanumeric }
  end
end
