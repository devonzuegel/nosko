module Extraction
  module Article
    class Evernote < ActiveRecord::Base
      self.table_name = 'evernote_article_extractions'

      belongs_to :article_extraction, dependent: :destroy
      validates *%i(article_extraction api_token), blank: false, uniqueness: true
    end
  end
end

