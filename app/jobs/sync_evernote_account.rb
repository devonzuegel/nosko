class SyncEvernoteAccount < Que::Job
  def run(en_account_id)
    Rails.logger.debug '> Syncing Evernote...'
    en_account = EvernoteAccount.find(en_account_id)

    count = 0
    en_account.retrieve_each_stale_guid do |stale_guid|
      count += 1
      Rails.logger.debug "> #{count}: Enqueuing note ##{stale_guid}..."
      SyncEvernoteNote.enqueue(stale_guid, en_account_id)
    end

    Rails.logger.debug "> Done! All #{count} notes synced."
    ActiveRecord::Base.transaction do
      en_account.update_attributes(last_accessed_at: 0.seconds.ago)
      destroy
    end
  end
end