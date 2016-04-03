class ArticleExtraction < ActiveRecord::Base
  enum source: %i(evernote)

  validates_presence_of %i(source)

  def extraction
    case source
    when :evernote
      Extraction::Article::Evernote.find(article_extraction_id: id)
    end
  end
end