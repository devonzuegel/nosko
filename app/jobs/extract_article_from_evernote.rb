class ExtractArticleFromEvernote < Que::Job
  def run(extractor_id)
    extractor = EvernoteExtractor.find(extractor_id)
    note      = extractor.retrieve_note
    # Instance method: evernote_account.find_note_by_guid(extractor.guid)

    ActiveRecord::Base.transaction do
      article = Article.create(note)
      extractor.update_attributes(article: article, last_accessed_at: Time.now.utc)
    end
  end
end