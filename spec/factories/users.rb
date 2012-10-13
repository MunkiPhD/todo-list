FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "johnSmith#{n}@email.com" }
    password "test123"
    password_confirmation "test123"

    factory :user_with_items do
      # this is ignored so that you can se teh count from the test and it will create that many items
      ignore do
        items_count 5
      end

      after(:create) do |user, evaluator|
        FactoryGirl.create_list(:item, evaluator.items_count, user: user)
      end
    end
  end
end

