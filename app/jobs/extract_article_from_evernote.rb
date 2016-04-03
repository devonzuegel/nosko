class ExtractArticleFromEvernote < Que::Job
  def run(extractor_id)
    extractor = Extractor::Article::Evernote[extractor_id]
    note      = extractor.retrieve_note

    ActiveRecord::Base.transaction do
      article = Article.create(note)
      extractor.update_attributes(article: article, last_accessed_at: Time.now.utc)

      destroy
    end
  end
end