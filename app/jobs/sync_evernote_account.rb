class SyncEvernoteAccount < Que::Job
  def run(en_account_id)
    puts '> Syncing Evernote...'
    en_account = EvernoteAccount.find(en_account_id)

    count = 0
    en_account.retrieve_each_stale_guid do |stale_guid|
      puts "> Enqueuing note ##{stale_guid}..."
      SyncEvernoteNote.enqueue(stale_guid, en_account_id)
      count += 1
      break if count > 10
    end

    puts '> Done! All notes synced.'
    ActiveRecord::Base.transaction do
      en_account.update_attributes(last_accessed_at: 0.seconds.ago)
      destroy
    end
  end
end