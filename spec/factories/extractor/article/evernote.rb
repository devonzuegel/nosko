FactoryGirl.define do
  factory :extractor_article_evernote, :class => Extractor::Article::Evernote do
    evernote_account
    guid { Faker::Lorem.characters(10)  }
  end
end
