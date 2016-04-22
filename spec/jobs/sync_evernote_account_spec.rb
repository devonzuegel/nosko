require 'que/testing'

describe "Testing SyncEvernoteAccount job" do
  before do
    Que.mode = :off
    stub_const('EvernoteClient', FakeEvernoteClient)
  end

  after do
    Que.mode = :sync
    SyncEvernoteAccount.jobs.clear
    SyncEvernoteNote.jobs.clear
  end

  describe 'SyncEvernoteAccount.enqueue' do
    before { @en_account = create(:evernote_account) }

    it 'enqueues one job' do
      id = @en_account.id
      expect { SyncEvernoteAccount.enqueue(id) }.to change { SyncEvernoteAccount.jobs.count }.by 1
    end
  end

  describe 'Running a SyncEvernoteAccount job' do
    before do
      user        = create(:user, :evernote_connected)
      @en_account = user.evernote_account
    end

    let(:time_since_last_accessed) { -> { Time.now - @en_account.last_accessed_at.to_time } }

    it 'enqueues one SyncEvernoteNote job' do
      expect(SyncEvernoteNote.jobs.count).to eq 0
      SyncEvernoteAccount.run(@en_account.id)
      expect(SyncEvernoteNote.jobs.count).to eq 4
    end

    it 'updates last_accessed_at to reflect sync time' do
      @en_account.update(last_accessed_at: 10.days.ago)
      expect(time_since_last_accessed.call).to be > 1
      SyncEvernoteAccount.run(@en_account.id)
      @en_account = EvernoteAccount.find(@en_account.id) # Refresh value in memory
      expect(time_since_last_accessed.call).to be < 1
    end

    it 'raises an error when given a non-existent user id' do
      expect { SyncEvernoteAccount.run(123) }.to raise_error ActiveRecord::RecordNotFound
    end
  end
end
