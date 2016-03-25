class EvernoteNote < ActiveRecord::Base
  belongs_to :article, dependent: :destroy

  REQUIRED_FIELDS = %i(guid article en_created_at en_updated_at active notebook_guid author article)
  OPTIONAL_FIELDS = %i()
  FIELDS          = REQUIRED_FIELDS + OPTIONAL_FIELDS

  validates_presence_of   REQUIRED_FIELDS
  validates_uniqueness_of :guid, :article

  def initialize(all_attributes)
    article_attributes, evernote_attributes = partition_attributes(all_attributes)
    article = Article.new(article_attributes)
    super(evernote_attributes.merge(article: article))
  end

  def update_attributes(all_attributes)
    article_attributes, evernote_attributes = partition_attributes(all_attributes)
    article.update_attributes(article_attributes)
    super(evernote_attributes)
  end

  def self.update_or_create!(all_attributes)
    match = find_by_guid( all_attributes.fetch(:guid) )
    return create!(all_attributes) if match.nil?

    match.update_attributes(all_attributes)
    match
  end

  private

  def partition_attributes(all_attributes)
    article_attributes  = all_attributes.slice(*Article::FIELDS)
    evernote_attributes = all_attributes.reject { |k,v| article_attributes.keys.include? k }
    return [article_attributes, evernote_attributes]
  end
end
