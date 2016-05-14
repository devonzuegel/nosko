require 'rails_helper'

RSpec.describe Extractor::Article::Evernote, type: :model do
  before do
    Que.mode = :off
    stub_const('EvernoteClient', FakeEvernoteClient)
  end

  describe 'Initializing an Evernote extractor' do
    subject { @extractor = create(:extractor_article_evernote) }

    it { should validate_uniqueness_of :guid             }
    it { should validate_presence_of   :guid             }
    it { should validate_presence_of   :evernote_account }

    it 'should have the expected table_name' do
      expect(Extractor::Article::Evernote.table_name).to eq 'evernote_extractors'
    end

    it 'should build a valid extractor' do
      expect(build(:extractor_article_evernote)).to be_valid
    end

    it 'should not yet have an article' do
      expect(build(:extractor_article_evernote).article).to be_nil
    end
  end

  describe 'retrieve_note' do
    it 'should create a new article if none with guid exists' do
      extractor = create(:extractor_article_evernote)
      expect(extractor.article).to be_nil
      extractor.retrieve_note
      expect(extractor.article).to_not be_nil
    end

    it 'should update article if one with guid exists and is unlocked', :focus do
      old_content = 'asdlkfjaslkdfja'
      extractor = create(:extractor_article_evernote, article: create(:article, content: old_content))
      expect(extractor.article).to_not be_nil
      expect(extractor.article.content).to eq old_content
      expect(extractor.last_accessed_at).to be_nil

      extractor.retrieve_note
      expect(extractor.article.content).to eq FakeEvernoteClient::PARSED_DUMMY_CONTENT
      expect(extractor.last_accessed_at).to be_within(1.second).of Time.now
    end

    it 'should not update article if one with guid exists and but is locked' do
      old_content    = 'asdlkfjaslkdfja'
      locked_article = create(:article, :locked, content: old_content)
      extractor      = create(:extractor_article_evernote, article: locked_article)
      expect(extractor.last_accessed_at).to be_nil

      expect(extractor.article).to_not be_nil
      expect(extractor.article.content).to eq old_content

      extractor.retrieve_note
      expect(extractor.article.content).to eq old_content
      expect(extractor.last_accessed_at).to be_within(1.second).of Time.now
    end
  end

  describe 'HIGHLIGHT_TAGS regex', :focus do
    subject(:regex) { Extractor::Article::Evernote::HIGHLIGHT_TAGS[:from] }

    it { should match('<span style="-evernote-highlighted:true; background-color:#FFFFb0">') }
    it { should match('<span style="-evernote-highlighted:true; background-color:#FFFFb0;">') }
    it { should match('<span style="-evernote-highlighted:true; background-color:#ffffb0">') }
    it { should match('<span style="-evernote-highlighted:true; background-color:#ffffb0;">') }
    it { should match('<span style="-evernote-highlighted: true; background-color: #aaaaaa">') }
    it { should match('<span style="-evernote-highlighted: true; background-color: #ffffb0;">') }
    it { should_not match('<span style="-evernote-highlighted: true; background-color: #zzzzzz;">') }
  end
end
