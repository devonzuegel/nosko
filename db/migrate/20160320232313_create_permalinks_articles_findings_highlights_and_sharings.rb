class CreatePermalinksArticlesFindingsHighlightsAndSharings < ActiveRecord::Migration
  def change
    create_table :permalinks do |t|
      t.text    :path, unique: true, null: false
      t.boolean :publicized, default: false
      t.boolean :trashed, default: false

      t.timestamps null: false
    end

    create_table :articles do |t|
      # Fields that apply to all findings
      t.references :user, index: true, foreign_key: true
      t.references :permalink, null: false, foreign_key: true
      t.string     :title, blank: false
      t.string     :source_url

      # Fields that are Article-specific
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
      t.integer    :share_by_default,    default: 0
      t.integer    :reminders_frequency, default: 0
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
