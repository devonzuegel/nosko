FactoryGirl.define do
  factory :article, :class => Finding::Article do |f|
    user
    title      { Faker::Lorem.sentence }
    source_url { Faker::Internet.url }
    content    { Faker::Lorem.paragraph }
    locked     false

    trait :trashed do
      after(:create) do |article|
        article.trash!
      end
    end

    trait :locked do
      locked    true
    end
  end
end
