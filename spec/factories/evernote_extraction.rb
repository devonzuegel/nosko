FactoryGirl.define do
  factory :evernote_extraction do |f|
    transient do
        data { {
            active:         true,
            author:         Faker::Name.name,
            en_created_at:  4.years.ago.utc,
            en_updated_at:  1.month.ago.utc,
            guid:           Faker::Lorem.characters(20),
            notebook_guid:  Faker::Lorem.characters(20),
            title:          Faker::Lorem.sentence,
            source_url:     Faker::Internet.url,
            content:        Faker::Lorem.paragraphs(3).join("\n"),
            user:           FactoryGirl.create(:user)
        } }
    end
    initialize_with { EvernoteExtraction.new(data) }
  end
end
