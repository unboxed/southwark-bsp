FactoryBot.define do
  factory :building_ownership do
    ownership_status { "building_developer" }
    full_name { "A developer" }
    email { "developer@example.com" }
    organisation { "ACME" }
  end
end
