require 'faker'

FactoryGirl.define do
  factory :item do
    sequence(:number) { |n| n }
    description { Faker::Lorem.sentence }
    association :user_id, :factory => :user
  end
end
