FactoryGirl.define do
  factory :user do
    name     'Test User'
    provider 'twitter'

    trait :evernote_connected do
      after(:create) do |user|
        create(:evernote_account, :evernote_connected, user: user)
      end
    end
  end
end
