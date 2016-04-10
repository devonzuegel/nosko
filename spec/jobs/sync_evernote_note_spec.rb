require "que/testing"

describe "Testing SyncEvernoteNote job" do
  let(:user) { create(:user, :evernote_connected) }

  before do
    EvernoteAccount.any_instance.stub(:each_stale_guid).and_yield('guid1')
  end

  after do
    SyncEvernoteNote.jobs.clear
    ExtractArticleFromEvernote.jobs.clear
  end

  describe 'SyncEvernoteNote.enqueue' do
    it 'enqueues one job' do
      expect(SyncEvernoteNote.jobs.length).to eq 0
      SyncEvernoteNote.enqueue(user.id)
      expect(SyncEvernoteNote.jobs.length).to eq 1
    end
  end

  describe 'Running a SyncEvernoteNote job' do
    let(:guid)    { Faker::Lorem.characters(20) }
    let(:run_job) { -> { SyncEvernoteNote.run(guid, user.id) } }

    describe 'when the an extractor with the guid/account pair doesnt exist yet' do
      it 'should enqueue ExtractArticleFromEvernote job' do
        extraction_jobs = ExtractArticleFromEvernote.jobs
        expect(run_job).to change { extraction_jobs.length }.by 1

        job_args = extraction_jobs.last[:args]
        expect(job_args).to eq([ Extractor::Article::Evernote.find_by(guid: guid).id ])
      end

      it 'should create new extractor' do
        expect(run_job).to change { Extractor::Article::Evernote.count }.by 1
      end
    end

    describe 'when the an extractor with the guid/account pair already exists' do
      before do
        Extractor::Article::Evernote.create!(guid: guid, evernote_account: user.evernote_account)
      end

      it 'should not create new extractor pair' do
        expect(run_job).to change { Extractor::Article::Evernote.count }.by 0
      end

      it 'should enqueue ExtractArticleFromEvernote job if guid/account pair already exists' do
        extraction_jobs = ExtractArticleFromEvernote.jobs
        expect(run_job).to change { extraction_jobs.length }.by 1

        job_args = extraction_jobs.last[:args]
        expect(job_args).to eq([ Extractor::Article::Evernote.find_by(guid: guid).id ])
      end

      it 'raises an error when given a non-existent user id' do
        expect { SyncEvernoteNote.run(guid, 123) }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
