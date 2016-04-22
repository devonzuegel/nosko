require "que/testing"

describe "Testing SyncEvernoteNote job" do
  let(:user) { create(:user, :evernote_connected) }

  before do
    Que.mode = :off
    stub_const('EvernoteClient', FakeEvernoteClient)
  end

  after do
    Que.mode = :sync
    SyncEvernoteNote.jobs.clear
  end

  describe 'SyncEvernoteNote.enqueue' do
    it 'enqueues one job' do
      expect(SyncEvernoteNote.jobs.length).to eq 0
      SyncEvernoteNote.enqueue(Faker::Lorem.characters(20))
      expect(SyncEvernoteNote.jobs.length).to eq 1
    end
  end

  describe 'Running a SyncEvernoteNote job' do
    let(:guid)    { Faker::Lorem.characters(20) }
    let(:run_job) { -> { SyncEvernoteNote.run(guid, user.evernote_account.id) } }

    it 'raises an error when given a non-existent user id' do
      expect { SyncEvernoteNote.run(guid, 123) }.to raise_error ActiveRecord::RecordNotFound
    end

    describe 'when neither the extractor nor article exist yet' do
      it 'should create new extractor' do
        expect(run_job).to change { Extractor::Article::Evernote.count }.by 1
      end

      it 'should create new article' do
        expect(run_job).to change { Finding::Article.count }.by 1
      end
    end

    describe 'when the extractor exists but the article does not' do
      before do
        Extractor::Article::Evernote.create!(guid: guid, evernote_account: user.evernote_account)
      end

      it 'should not create new extractor' do
        expect(run_job).to change { Extractor::Article::Evernote.count }.by 0
      end

      it 'should create new article' do
        expect(run_job).to change { Finding::Article.count }.by 1
      end
    end

    describe 'when both the extractor and article exist' do
      before do
        @extractor = Extractor::Article::Evernote.create!(guid: guid, evernote_account: user.evernote_account)
        @extractor.retrieve_note
      end

      it 'should not create new extractor' do
        expect(run_job).to change { Extractor::Article::Evernote.count }.by 0
      end

      it 'should not create new article' do
        expect(run_job).to change { Finding::Article.count }.by 0
      end

      it 'should update article if one corresponding extractor already exists' do
        @extractor.article.update_attributes(title: 'blah')
        expect(@extractor.article.title).to eq 'blah'

        run_job.call

        @extractor = Extractor::Article::Evernote.find(@extractor.id)
        expect(@extractor.article.title).to eq 'This is a test'
      end

      it 'should update the :last_accessed_at attribute' do
        time_since_last_accessed = -> { Time.now - @extractor.last_accessed_at.to_time }
        @extractor.update_attributes(last_accessed_at: 1.day.ago)
        expect(time_since_last_accessed.call).to be > 1.0

        run_job.call

        @extractor = Extractor::Article::Evernote.find(@extractor.id)
        expect(time_since_last_accessed.call).to be <= 1.0
      end
    end
  end
end
