# Job to extract the note corresponding to a given guid.
class SyncEvernoteNote < Que::Job
  def run(guid, en_account_id)
    ActiveRecord::Base.transaction do
      account   = EvernoteAccount.find(en_account_id)
      attrs     = { guid: guid, evernote_account: account }
      extractor = Extractor::Article::Evernote.find_or_create_by(attrs)

      ActiveRecord::Base.transaction do
        extractor.retrieve_note

        Rails.logger.debug "> Note ##{guid} synced!..."
        destroy
      end
    end
  end
end