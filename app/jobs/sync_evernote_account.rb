class SyncEvernoteAccount < Que::Job
  def run(en_account_id)
    puts '> Syncing Evernote...'
    en_account = EvernoteAccount.find(en_account_id)

    count = 0
    en_account.each_stale_guid do |stale_guid|
      ActiveRecord::Base.transaction do
        puts "> Enqueuing note ##{stale_guid}..."
        SyncEvernoteNote.enqueue(stale_guid, en_account_id)
      end
      count += 1
      break if count > 10
    end

    ActiveRecord::Base.transaction do
      destroy
      en_account.update_attributes(last_accessed_at: 0.seconds.ago)
    end
  end
end