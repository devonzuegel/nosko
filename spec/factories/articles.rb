FactoryGirl.define do
  factory :article do
    title      { Faker::Lorem.sentence }
    source_url { Faker::Internet.url }
    content    { Faker::Lorem.paragraph }
  end
end
