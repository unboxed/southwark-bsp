FactoryBot.define do
  factory :building do
    address { "A place full of wonders" }
    UPRN { rand 10**12 }
  end
end
