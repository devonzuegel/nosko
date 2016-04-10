module Extractor
  module Article
    class Evernote < ActiveRecord::Base
      self.table_name = 'evernote_extractors'

      belongs_to :evernote_account

      validates_uniqueness_of %i(guid)
      validates *%i(guid evernote_account), blank: false

      def retrieve_note
        note = evernote_account.find_note_by_guid(guid)
        {
          content:     note[:content],
          source_url:  note[:source_url],
          title:       note[:title],
        }
      end
    end
  end
end

