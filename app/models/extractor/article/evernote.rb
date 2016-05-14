module Extractor
  module Article
    class Evernote < ActiveRecord::Base
      self.table_name = 'evernote_extractors'

      belongs_to :evernote_account
      belongs_to :article, class_name: 'Finding::Article'

      validates_uniqueness_of %i(guid)
      validates_presence_of *%i(guid evernote_account), allow_blank: false

      def retrieve_note
        en_client  = EvernoteClient.new(auth_token: evernote_account.auth_token)
        note_attrs = en_client.find_note_by_guid(guid).slice(:content, :source_url, :title)

        if article.nil?
          update(article: create_article!(note_attrs))
        elsif article.unlocked?
          article.update_attributes!(note_attrs)
        end

        update(last_accessed_at: 0.seconds.ago)
      end

      def create_article!(note_attrs)
        Finding::Article.create!(note_attrs.merge(user: evernote_account.user))
      end
    end
  end
end

