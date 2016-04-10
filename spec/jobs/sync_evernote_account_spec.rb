require "que/testing"

describe "Testing SyncEvernoteAccount job" do
  let(:user) { create(:user, :evernote_connected) }

  before do
    EvernoteAccount.any_instance.stub(:each_stale_guid).and_yield('guid1')
  end

  after { SyncEvernoteAccount.jobs.clear }

  describe 'SyncEvernoteAccount.enqueue' do
    it 'enqueues one job' do
      expect(SyncEvernoteAccount.jobs.length).to eq 0
      SyncEvernoteAccount.enqueue(user.id)
      expect(SyncEvernoteAccount.jobs.length).to eq 1
    end
  end

  describe 'Running a SyncEvernoteAccount job' do
    it 'enqueues one SyncEvernoteNote job' do
      expect(SyncEvernoteNote.jobs.length).to eq 0
      SyncEvernoteAccount.run(user.evernote_account.id)
      expect(SyncEvernoteNote.jobs.length).to eq 1

      user.evernote_account.stale_guids.each_with_index do |guid, i|
        expected_args = [guid, user.evernote_account.id]
        expect(SyncEvernoteNote.jobs[i]['args']).to eq expected_args
      end
    end

    it 'raises an error when given a non-existent user id' do
      expect { SyncEvernoteAccount.run(123) }.to raise_error ActiveRecord::RecordNotFound
    end
  end
end
