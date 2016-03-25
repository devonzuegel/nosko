class CreateEvernoteNotes < ActiveRecord::Migration
  def change
    create_table    :evernote_notes do |t|
      t.string      :guid
      t.datetime    :en_created_at
      t.datetime    :en_updated_at
      t.boolean     :active
      t.string      :notebook_guid
      t.string      :author
      t.references  :evernote_account, index: true, foreign_key: true
    end
  end
end
