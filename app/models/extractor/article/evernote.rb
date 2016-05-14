class Extractor::Article::Evernote < ActiveRecord::Base
  self.table_name = 'evernote_extractors'

  belongs_to :evernote_account
  belongs_to :article, class_name: 'Finding::Article'

  validates_uniqueness_of %i(guid)
  validates_presence_of *%i(guid evernote_account), allow_blank: false

  ARTICLE_ATTRIBUTES = %i(content source_url title)

  EN_HIGHLIGHT_TAG = %r{
    <span[ \t]+                                   # Open span tag
      style="-evernote\-highlighted\:[ \t]*true;  # Evernote highlighted attribute
      [ \t]+                                      # Arbitrary white space
      background-color\:[ \t]*\#\h+               # Background color must be a hex value
      (;)?"                                       # Optional semicolon at the end
    >                                             # Close span tag
  }ix                                             # Case-insensitive, allow multi-line regex

  def retrieve_note
    if article.nil?
      update(article: create_article!)
    elsif article.unlocked?
      update_article_parsed!
    end

    update(last_accessed_at: 0.seconds.ago)
  end

  def update_article_parsed!
    article.update_attributes!(parsed_article_attrs)
  end

  private

  def create_article!
    Finding::Article.create!(parsed_article_attrs)
  end

  def en_client
    @en_client ||= EvernoteClient.new(auth_token: evernote_account.auth_token)
  end

  def article_attrs
    old_attrs = article.nil? ? {} : article.attributes.deep_symbolize_keys.slice(*ARTICLE_ATTRIBUTES).compact
    new_attrs = en_client.find_note_by_guid(guid).slice(*ARTICLE_ATTRIBUTES)
    if article && article.locked?
      @article_attrs = old_attrs.reverse_merge(new_attrs)
    else
      @article_attrs = old_attrs.merge(new_attrs)
    end
    @article_attrs.merge!(user: evernote_account.user)
  end

  def parsed_article_attrs
    old_content = article_attrs[:content]
    @article_attrs[:content] = old_content.gsub(EN_HIGHLIGHT_TAG).with_index { |_, i| highlight_replacement(i) }
    @article_attrs
  end

  def highlight_replacement(id)
    %Q(<span class="highlight en-highlight" id="en-highlight-#{id}">)
  end
end