class CreateEvernoteExtractors < ActiveRecord::Migration
  def change
    create_table :evernote_extractors do |t|
      t.string     :guid,             blank: false, unique: true
      t.datetime   :last_accessed_at
      t.references :evernote_account, index: true, foreign_key: true
      t.references :article,          index: true, foreign_key: true
    end
  end
end
