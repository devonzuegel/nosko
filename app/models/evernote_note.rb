class EvernoteNote < ActiveRecord::Base
  belongs_to :article, dependent: :destroy
  validates  :article, presence: true

  def initialize(all_attributes)
    article_attributes  = all_attributes.slice(*Article::FIELDS)
    evernote_attributes = all_attributes.slice!(*Article::FIELDS)
    article = Article.create!(article_attributes)
    super(evernote_attributes.merge(article: article))
  end
end
