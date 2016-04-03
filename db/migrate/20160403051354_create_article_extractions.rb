class CreateArticleExtractions < ActiveRecord::Migration
  def change
    create_table :article_extractions do |t|
      t.references :article, index: true, foreign_key: true
      t.integer    :source, blank: false
      t.references :extraction_id, index: true, foreign_key: true
    end
  end
end
