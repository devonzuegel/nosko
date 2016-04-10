# Job to extract the note corresponding to a given guid.
class SyncEvernoteNote < Que::Job
  def run(guid, en_account_id)
    account         = EvernoteAccount.find(en_account_id)  # Raises error if no corresponding account.
    extractor_attrs = { guid: guid, evernote_account: account }
    extractor       = Extractor::Article::Evernote.find_by(extractor_attrs)

    if extractor.nil?
      ActiveRecord::Base.transaction do
        extractor = Extractor::Article::Evernote.create(extractor_attrs)
        ExtractArticleFromEvernote.enqueue(extractor.id)

        puts 'Created extractor:'
        ap extractor
        destroy
      end
    else
      # Handle update
      raise NotImplementedError
    end
  end
end