module Extractor
  module Article
    class Evernote < ActiveRecord::Base
      self.table_name = 'evernote_extractors'

      belongs_to :evernote_account
      belongs_to :article, class_name: 'Finding::Article'

      validates_uniqueness_of %i(guid)
      validates *%i(guid evernote_account), blank: false

      def retrieve_note
        en_client  = EvernoteClient.new(auth_token: evernote_account.auth_token)
        note_attrs = en_client.find_note_by_guid(guid).slice(:content, :source_url, :title)

        if article && !article.locked?
          article.update_attributes!(note_attrs)
        else
          article = Finding::Article.create!(note_attrs.merge(user: evernote_account.user))
          update(article: article)
        end

        update(last_accessed_at: 0.seconds.ago)
      end
    end
  end
end

