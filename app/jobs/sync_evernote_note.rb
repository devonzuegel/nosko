class SyncEvernoteNote < Que::Job
  def run(guid, en_account_id)
    evernote_account = EvernoteAccount.find(en_account_id)  # Raises error if no corresponding account.
    extractor        = EvernoteExtractor.find_by(guid: guid, evernote_account: evernote_account)

    if extractor.nil?
      ActiveRecord::Base.transaction do
        extractor = EvernoteExtractor.create(guid: guid, evernote_account: evernote_account)
        ExtractArticleFromEvernote.enqueue(extractor.id)
      end
    else
      # Handle update
      raise NotImplementedError
    end
  end
end