require 'que/testing'

describe "Testing SyncEvernoteAccount job" do
  before do
    EvernoteAccount.any_instance.stub(:each_stale_guid).and_yield('guid1')
  end

  after do
    SyncEvernoteAccount.jobs.clear
    SyncEvernoteNote.jobs.clear
  end

  describe 'SyncEvernoteAccount.enqueue' do
    it 'enqueues one job' do
      expect(SyncEvernoteAccount.jobs.length).to eq 0
      SyncEvernoteAccount.enqueue(123123)
      expect(SyncEvernoteAccount.jobs.length).to eq 1
    end
  end

  describe 'Running a SyncEvernoteAccount job' do
    before do
      user        = create(:user, :evernote_connected)
      @en_account = user.evernote_account
    end

    let(:time_since_last_accessed) { -> { Time.now - @en_account.last_accessed_at.to_time } }

    it 'enqueues one SyncEvernoteNote job' do
      expect(SyncEvernoteNote.jobs.length).to eq 0
      SyncEvernoteAccount.run(@en_account.id)
      expect(SyncEvernoteNote.jobs.length).to eq 1

      @en_account.stale_guids.each_with_index do |guid, i|
        expected_args = [guid, @en_account.id]
        expect(SyncEvernoteNote.jobs[i][:args]).to eq expected_args
      end
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
