FactoryGirl.define do
  factory :finding do
    title { Faker::Lorem.sentence }
    kind  'Article'
    url   { Faker::Internet.url }
  end

end
