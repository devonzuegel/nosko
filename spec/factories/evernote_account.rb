FactoryGirl.define do
  factory :evernote_account do
    user

    trait :evernote_connected do
      auth_token { Faker::Lorem.characters(10) }
    end

    trait :accessed do
      last_accessed_at { Faker::Time.between(2.days.ago, Time.now) }
    end
  end
end
