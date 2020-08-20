FactoryBot.define do
  factory :building do
    association :manager, factory: :building_manager

    address { "A place full of wonders" }
    UPRN { rand 10**12 }
  end
end
