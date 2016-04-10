require "que/testing"

describe "Testing ExtractArticleFromEvernote job" do
  let(:user) { create(:user, :evernote_connected) }

  before do
    stub_const('EvernoteClient', FakeEvernoteClient)
  end

  after { ExtractArticleFromEvernote.jobs.clear }

  describe 'ExtractArticleFromEvernote.enqueue' do
    it 'enqueues one job' do
      expect(SyncEvernoteNote.jobs.length).to eq 0
      SyncEvernoteNote.enqueue(user.id)
      expect(SyncEvernoteNote.jobs.length).to eq 1
    end
  end

  describe 'Running a ExtractArticleFromEvernote job on a not-yet existing article' do
    let(:extractor) do
      Extractor::Article::Evernote.create(
        evernote_account: user.evernote_account,
        last_accessed_at: nil,
        article_id:       nil
      )
    end

    it 'should create a new article' do
      expect { ExtractArticleFromEvernote.run(extractor.id) }.to change { Finding::Article.count }.by 1
    end

    it 'should raise an error when given an invalid extractor_id' do
      expect { ExtractArticleFromEvernote.run(123) }.to raise_error ActiveRecord::RecordNotFound
    end
  end

  describe 'Running a ExtractArticleFromEvernote job for an article that already exists' do
    before do
      @extractor = Extractor::Article::Evernote.create(
        evernote_account: user.evernote_account,
        created_at:       2.days.ago,
        last_accessed_at: 1.day.ago,
        article:          create(:article, title: 'original title')
      )
    end

    let(:extract)                  { -> { ExtractArticleFromEvernote.run(@extractor.id)  } }
    let(:time_since_last_accessed) { -> { Time.now - @extractor.last_accessed_at.to_time } }

    it 'should not create a new article' do
      expect { extract.call }.to change { Finding::Article.count }.by 0
    end

    it 'should update article if one corresponding extractor already exists' do
      extract.call

      @extractor = Extractor::Article::Evernote.find(@extractor.id)
      expect(@extractor.article.title).to eq 'This is a test'
    end

    it 'should update the :last_accessed_at attribute' do
      expect(time_since_last_accessed.call).to be > 1.0

      extract.call

      @extractor = Extractor::Article::Evernote.find(@extractor.id)
      expect(time_since_last_accessed.call).to be <= 1.0
    end
  end
end
