FactoryGirl.define do
  factory :article do
    title   { Faker::Lorem.sentence }
    url     { Faker::Internet.url }
    content { Faker::Lorem.paragraph }
  end
end
