class CreatePermalinksArticlesFindingsHighlightsAndSharings < ActiveRecord::Migration
  def change
    create_table :permalinks do |t|
      t.text    :path, unique: true, null: false
      t.boolean :publicized, default: false
      t.boolean :trashed, default: false

      t.timestamps null: false
    end

    create_table :articles do |t|
      # All findings
      t.references :permalink, null: false, foreign_key: true
      t.string     :url, blank: false
      t.string     :title, blank: false
      t.string     :kind, blank: false

      # Article kind specific
      t.text       :content

      t.timestamps null: false
    end

    create_table :highlights do |t|
      t.references :article, index: true, foreign_key: true, null: false
      t.references :permalink, null: false, foreign_key: true
      t.text       :content

      t.timestamps null: false
    end

    create_table :sharings do |t|
      t.boolean    :share_by_default, default: false
      t.string     :reminders_frequency, default: 'daily'
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
