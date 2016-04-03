class ArticleExtraction < ActiveRecord::Base
  enum source: %i(evernote)

  validates_presence_of %i(source)
end