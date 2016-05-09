FactoryGirl.define do
  factory :article, :class => Finding::Article do |f|
    user
    title      { Faker::Lorem.sentence }
    source_url { Faker::Internet.url }
    content    { Faker::Lorem.paragraph }

    trait :trashed do
      after(:create) do |article|
        article.trash!
      end
    end
  end
end
