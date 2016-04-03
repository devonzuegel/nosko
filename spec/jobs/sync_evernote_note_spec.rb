require "que/testing"

describe "Testing SyncEvernoteNote job" do
  after { SyncEvernoteNote.jobs.clear }

  it "Stores a job"
    # SyncEvernoteNote.enqueue("foo")

    # js = MyJob.jobs
    # js.length.must_equal 1
    # js.first["args"].must_equal ["foo"]
    # js.first["job_class"].must_equal "MyJob"
end
