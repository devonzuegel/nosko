FactoryGirl.define do
  factory :article, :class => Finding::Article do |f|
    user
    title      { Faker::Lorem.sentence }
    source_url { Faker::Internet.url }
    content    { Faker::Lorem.paragraph }
    locked     false

    trait :public do
      after(:create) do |article|
        article.update_attributes(visibility: 'Public')
      end
    end

    trait :only_me do
      after(:create) do |article|
        article.update_attributes(visibility: 'Only me')
      end
    end

    trait :friends do
      after(:create) do |article|
        article.update_attributes(visibility: 'Friends')
      end
    end

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
