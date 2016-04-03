class SyncEvernoteAccount < Que::Job
  def run(en_account_id)
    evernote_account = EvernoteAccount[en_account_id]

    evernote_account.each_stale_guid do |stale_guid|
      SyncEvernoteNote.enqueue(stale_guid, en_account_id)
    end

    # TODO: When all are done, update last_accessed_at
  end
end