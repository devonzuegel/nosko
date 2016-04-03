FactoryGirl.define do
  factory :article, :class => Finding::Article do |f|
    title      { Faker::Lorem.sentence }
    source_url { Faker::Internet.url }
    content    { Faker::Lorem.paragraph }
  end
end
