FactoryBot.define do
  factory :contact do
    association :user
    title { Faker::Lorem.characters(number: 5) }
    body { Faker::Lorem.characters(number: 20) }
  end
end
