FactoryBot.define do
  factory :post do
    association :user
    post_image_id {Faker::Lorem.character(number:10)}
    pet { Faker::Lorem.character(number:5) }
    body { Faker::Lorem.characters(number:100) }
  end
end