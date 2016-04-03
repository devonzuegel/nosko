module Extraction
  module Article
    class Evernote < ActiveRecord::Base
      def self.table_name
        'evernote_article_extractions'
      end
    end
  end
end

