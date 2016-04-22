class SyncEvernoteAccount < Que::Job
  def run(en_account_id)
    Rails.logger.debug '> Syncing Evernote...'
    en_account = EvernoteAccount.find(en_account_id)

    en_account.retrieve_each_stale_guid do |stale_guid|
      Rails.logger.debug "> Enqueuing note ##{stale_guid}..."
      SyncEvernoteNote.enqueue(stale_guid, en_account_id)
    end

    Rails.logger.debug '> Done! All notes synced.'
    ActiveRecord::Base.transaction do
      en_account.update_attributes(last_accessed_at: 0.seconds.ago)
      destroy
    end
  end
end