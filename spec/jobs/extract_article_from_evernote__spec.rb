require "que/testing"

describe "Testing ExtractArticleFromEvernote job" do
  after { ExtractArticleFromEvernote.jobs.clear }

  it "Stores a job"
    # ExtractArticleFromEvernote.enqueue("foo")

    # js = MyJob.jobs
    # js.length.must_equal 1
    # js.first["args"].must_equal ["foo"]
    # js.first["job_class"].must_equal "MyJob"
end
