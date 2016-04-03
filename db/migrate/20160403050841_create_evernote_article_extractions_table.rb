class CreateEvernoteArticleExtractionsTable < ActiveRecord::Migration
  def change
    create_table :evernote_article_extractions_tables do |t|
      t.string :api_token
      t.datetime :last_accessed_at
      t.references :article, index: true, foreign_key: true
    end
  end
end
