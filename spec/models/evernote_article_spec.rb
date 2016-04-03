require 'rails_helper'

RSpec.describe EvernoteArticle, type: :model do
  describe 'basic model' do
    it 'should be valid' do
      expect(build(:evernote_article).valid?).to be true
    end

    it 'should create an evernote_article' do
      expect { create(:evernote_article) }.to change { EvernoteArticle.count }.by 1
    end

    # it 'should create a corresponding article' do
    #   expect { create(:evernote_article) }.to change { Finding::Article.count }.by 1
    # end
  end

  # describe 'update_or_create!' do
  #   let(:data) { {
  #     active:         true,
  #     author:         Faker::Name.name,
  #     en_created_at:  4.years.ago.utc,
  #     en_updated_at:  1.month.ago.utc,
  #     guid:           Faker::Lorem.characters(20),
  #     notebook_guid:  Faker::Lorem.characters(20),
  #     title:          Faker::Lorem.sentence,
  #     source_url:     Faker::Internet.url,
  #     content:        Faker::Lorem.paragraphs(3).join("\n"),
  #   } }

  #   it 'should create a new evernote_article if none already exists' do
  #     expect(EvernoteArticle.count).to be 0
  #     expect { EvernoteArticle.update_or_create!(data) }.to change { EvernoteArticle.count }.by 1
  #   end

  #   it 'should create a new corresponding article if none already exists' do
  #     expect(Finding::Article.count).to be 0
  #     expect { @en = EvernoteArticle.update_or_create!(data) }.to change { Finding::Article.count }.by 1
  #     expect(@en.article.id).to eq Finding::Article.first.id
  #   end

  #   it 'should update existing evernote_article' do
  #     expect(EvernoteArticle.count).to be 0
  #     EvernoteArticle.update_or_create!(data)
  #     expect(EvernoteArticle.count).to be 1

  #     new_author = 'New author!'
  #     new_data    = data.merge(author: new_author)
  #     expect(new_data[:author]).to eq new_author

  #     expect { @en = EvernoteArticle.update_or_create!(new_data) }.to change { EvernoteArticle.count }.by 0
  #     expect(@en.author).to eq new_author
  #   end

  #   it 'should update existing article associated with evernote_article' do
  #     expect(Finding::Article.count).to be 0
  #     EvernoteArticle.update_or_create!(data)
  #     expect(Finding::Article.count).to be 1

  #     new_title = 'New title!'
  #     new_data    = data.merge(title: new_title)
  #     expect(new_data[:title]).to eq new_title

  #     expect { @en = EvernoteArticle.update_or_create!(new_data) }.to change { Finding::Article.count }.by 0
  #     expect(@en.article.title).to eq new_title
  #   end
  # end
#######
  # subject { build(:evernote_article) }

  # it { should validate_presence_of(:guid)          }
  # it { should validate_presence_of(:article)       }
  # it { should validate_presence_of(:en_created_at) }
  # it { should validate_presence_of(:en_updated_at) }
  # it { should validate_presence_of(:active)        }
  # it { should validate_presence_of(:notebook_guid) }
  # it { should validate_presence_of(:author)        }
  # it { should validate_presence_of(:article)       }

  # it { should validate_uniqueness_of(:guid)        }
  # it { should validate_uniqueness_of(:article)     }
end
