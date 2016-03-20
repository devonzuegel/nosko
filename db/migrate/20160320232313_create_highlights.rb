class CreateHighlights < ActiveRecord::Migration
  def change
    create_table :highlights do |t|
      t.references :finding, index: true, foreign_key: true
      t.string :permalink
      t.text :content

      t.timestamps null: false
    end
  end
end
