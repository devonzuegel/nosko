class CreateEvernoteNotes < ActiveRecord::Migration
  def change
    create_table    :evernote_notes do |t|
      t.string      :guid,            null: false
      t.datetime    :en_created_at,   null: false
      t.datetime    :en_updated_at,   null: false
      t.boolean     :active,          null: false
      t.string      :notebook_guid,   null: false
      t.string      :author,          null: false
      t.references  :article,         null: false, index: true, foreign_key: true
    end
  end
end
