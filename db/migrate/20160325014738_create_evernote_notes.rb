class CreateEvernoteNotes < ActiveRecord::Migration
  def change
    create_table :evernote_notes do |t|
      t.string :guid
      t.datetime :en_created_at
      t.datetime :en_updated_at
      t.boolean :active
      t.string :notebook_guid
      t.string :author
    end
  end
end
