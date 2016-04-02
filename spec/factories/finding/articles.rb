FactoryGirl.define do
  factory :article, :class => Finding::Article do |f|
    title      { Faker::Lorem.sentence }
    source_url { Faker::Internet.url }
    content    { Faker::Lorem.paragraph }
    user       { FactoryGirl.create(:user) }
    # f.before(:create)   { |article| article.user = create(:user) }
  end
end
