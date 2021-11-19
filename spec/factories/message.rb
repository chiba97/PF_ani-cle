FactoryBot.define do
  factory :message do
    association :user
    association :room
    message { Faker::Lorem.characters(number:30) }
  end
end