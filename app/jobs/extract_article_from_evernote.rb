class ExtractArticleFromEvernote < Que::Job
  def run(extractor_id)
    ActiveRecord::Base.transaction do
      extractor = Extractor::Article::Evernote.find(extractor_id)
      extractor.retrieve_note
      destroy
    end
  end
end