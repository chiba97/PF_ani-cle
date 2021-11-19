FactoryBot.define do
  factory :notification do
    association :visited
    association :visitor
    association :post
    association :comment
    association :room
    association :message
  end
end