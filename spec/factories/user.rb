FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    pet { Faker::Lorem.characters(number: 10) }
    introduction { Faker::Lorem.characters(number: 30) }
    email { Faker::Internet.email }
    password { 'password' }
    password_confirmation { 'password' }
  end
end