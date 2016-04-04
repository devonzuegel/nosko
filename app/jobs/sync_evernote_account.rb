class SyncEvernoteAccount < Que::Job
  def run(en_account_id)
    puts '> Syncing Evernote...'
    en_account = EvernoteAccount.find(en_account_id)

    ap en_account

    en_account.each_stale_guid do |stale_guid|
      puts "> Enqueuing note ##{stale_guid}..."
      SyncEvernoteNote.enqueue(stale_guid, en_account_id)
      break
    end
    destroy

    # TODO: When all are done, update last_accessed_at
  end
end