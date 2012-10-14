require 'faker'

FactoryGirl.define do
  factory :item do
    sequence(:number) { |n| n }
    description { Faker::Lorem.sentence(3) }
    association :user_id, :factory => :user
  end
end
