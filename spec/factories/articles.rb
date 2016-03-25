FactoryGirl.define do
  factory :article do |f|
    title      { Faker::Lorem.sentence }
    source_url { Faker::Internet.url }
    content    { Faker::Lorem.paragraph }

    f.after(:build) { |article| article.user = build(:user) }
  end
end
