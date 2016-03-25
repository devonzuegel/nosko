class EvernoteNote < ActiveRecord::Base
  belongs_to :article, dependent: :destroy

  REQUIRED_FIELDS = %i(guid article en_created_at en_updated_at active notebook_guid author article)
  OPTIONAL_FIELDS = %i()
  FIELDS          = REQUIRED_FIELDS + OPTIONAL_FIELDS

  validates_presence_of   REQUIRED_FIELDS
  validates_uniqueness_of :guid, :article

  def initialize(all_attributes)
    article_attributes  = all_attributes.slice(*Article::FIELDS)
    evernote_attributes = all_attributes.slice!(*Article::FIELDS)
    article = Article.new(article_attributes)
    super(evernote_attributes.merge(article: article))
  end

  def save!
    article.save
    super
  end

  def self.update_or_create!(all_attributes)
    ap all_attributes
  end
end
