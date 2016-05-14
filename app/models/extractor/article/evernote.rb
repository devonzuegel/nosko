class Extractor::Article::Evernote < ActiveRecord::Base
  self.table_name = 'evernote_extractors'

  belongs_to :evernote_account
  belongs_to :article, class_name: 'Finding::Article'

  validates_uniqueness_of %i(guid)
  validates_presence_of *%i(guid evernote_account), allow_blank: false

  NOTE_ATTRS = %i(content source_url title)

  HIGHLIGHT_TAGS  = {
    from: /<span[ \t]+style="-evernote-highlighted:[ \t]*true;[ \t]+background-color:#FFFFb0">/,
    to:   '<span class="highlight en-highlight">'
  }

  def retrieve_note
    if article.nil?
      update(article: create_article!)
    elsif article.unlocked?
      article.update_attributes!(note_attrs)
    end

    update(last_accessed_at: 0.seconds.ago)
  end

  private

  def create_article!
    Finding::Article.create!(note_attrs.merge(user: evernote_account.user))
  end

  def en_client
    @en_client ||= EvernoteClient.new(auth_token: evernote_account.auth_token)
  end

  def note_attrs
    @note_attrs ||= en_client.find_note_by_guid(guid).slice(*NOTE_ATTRS)
    replace_highlights!
    @note_attrs
  end

  def replace_highlights!
    old_val = @note_attrs[:content]
    @note_attrs[:content] = old_val.gsub(/#{HIGHLIGHT_TAGS[:from]}/i, HIGHLIGHT_TAGS[:to])
  end
end