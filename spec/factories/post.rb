FactoryBot.define do
  factory :post do
    post_image_id { Faker::Lorem.characters(number: 10) }
    pet { Faker::Lorem.characters(number: 5) }
    body { Faker::Lorem.characters(number: 100) }
    association :user
  end
end
