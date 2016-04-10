class ExtractArticleFromEvernote < Que::Job
  def run(extractor_id)
    extractor = Extractor::Article::Evernote.find(extractor_id)

    ActiveRecord::Base.transaction do
      extractor.retrieve_note
      extractor.update_attributes(last_accessed_at: 0.seconds.ago)
      destroy
    end
  end
end