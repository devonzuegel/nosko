FactoryGirl.define do
  factory :user do
    name     'Test User'
    provider 'twitter'

    trait :evernote_connected do
      after(:create) do |u|
        u.evernote_account.update_attributes(auth_token: Faker::Lorem.characters(10))
      end
    end

    trait :public_by_default do
      after(:create) do |u|
        u.sharing.update_attributes(:public => true)
      end
    end
  end
end
