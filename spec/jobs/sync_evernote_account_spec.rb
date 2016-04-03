require "que/testing"

describe "Testing SyncEvernoteAccount job" do
  let(:user) { create(:user, :evernote_connected) }
  after { SyncEvernoteAccount.jobs.clear }

  it "Stores a job"
    # SyncEvernoteAccount.enqueue("foo")

    # js = MyJob.jobs
    # js.length.must_equal 1
    # js.first["args"].must_equal ["foo"]
    # js.first["job_class"].must_equal "MyJob"
end
