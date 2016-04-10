# Job to extract the note corresponding to a given guid.
class SyncEvernoteNote < Que::Job
  def run(guid, en_account_id)
    account         = EvernoteAccount.find(en_account_id)
    extractor_attrs = { guid: guid, evernote_account: account }
    extractor       = Extractor::Article::Evernote.find_or_create_by(extractor_attrs)

    ActiveRecord::Base.transaction do
      ExtractArticleFromEvernote.enqueue(extractor.id)
      destroy
    end
  end
end