class CreateEvernoteArticleExtractions < ActiveRecord::Migration
  def change
    create_table :evernote_article_extractions do |t|
      t.string     :api_token, blank: false
      t.datetime   :last_accessed_at
      t.references :article, index: true, foreign_key: true
    end
  end
end
