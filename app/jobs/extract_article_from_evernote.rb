class ExtractArticleFromEvernote < Que::Job
  def run(extractor_id)
    puts "\n\n3) -----------------------------------------------------------------\n\n"
    extractor = Extractor::Article::Evernote.find(extractor_id)
    note      = extractor.retrieve_note

    puts 'Extracted note:'
    ap note
    puts "\n\nEND ----------------------------------------------------------------\n\n"
    ActiveRecord::Base.transaction do
      # article = Article.create(note)
      # extractor.update_attributes(article: article, last_accessed_at: Time.now.utc)

      destroy
    end
  end
end