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

    describe 'when the an extractor with the guid/account pair doesnt exist yet' do
      it 'should create new extractor' do
        expect(run_job).to change { Extractor::Article::Evernote.count }.by 1
      end
    end

    describe 'when the an extractor with the guid/account pair already exists' do
      before do
        Extractor::Article::Evernote.create!(guid: guid, evernote_account: user.evernote_account)
      end

      it 'should not create new extractor' do
        expect(run_job).to change { Extractor::Article::Evernote.count }.by 0
      end

      it 'raises an error when given a non-existent user id' do
        expect { SyncEvernoteNote.run(guid, 123) }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
