FactoryGirl.define do
  factory :article_extraction do |f|
    article_id  { FactoryGirl.create(:article).id }
    source     :evernote
  end
end
