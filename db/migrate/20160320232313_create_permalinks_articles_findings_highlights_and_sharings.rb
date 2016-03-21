class CreatePermalinksArticlesFindingsHighlightsAndSharings < ActiveRecord::Migration
  def change
    create_table :permalinks do |t|
      t.text :path, unique: true, null: false

      t.timestamps null: false
    end

    create_table :findings do |t|
      t.references :permalink, null: false, foreign_key: true
      t.string :url
      t.string :title
      t.string :kind

      t.timestamps null: false
    end

    create_table :articles do |t|
      t.references :finding, index: true, foreign_key: true, null: false
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
