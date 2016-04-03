class EvernoteExtraction < ActiveRecord::Base
  belongs_to :article, class_name: Finding::Article, dependent: :destroy

  validates_uniqueness_of :guid, :article

  HIGHLIGHT_TAGS  = {
    from: '<span style="-evernote-highlighted:true; background-color:#FFFFb0">',
    to:   '<span class="highlight en-highlight">'
  }

  def initialize(all_attributes)
    article_attributes, evernote_attributes = partition_attributes(all_attributes)
    article = Finding::Article.new(article_attributes)
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
    if all_attributes[:user]
      all_attributes[:user_id] = all_attributes.delete(:user).id
    end
    article_attributes  = all_attributes.slice(*Finding::Article.visible_fields)
    evernote_attributes = all_attributes.reject { |k,v| article_attributes.keys.include? k }

    return [replace_highlights(article_attributes), evernote_attributes]
  end

  def replace_highlights(attributes)
    attributes[:content].gsub!(HIGHLIGHT_TAGS[:from], HIGHLIGHT_TAGS[:to])
    attributes
  end
end
