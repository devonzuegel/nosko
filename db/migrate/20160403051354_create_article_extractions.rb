class CreateArticleExtractions < ActiveRecord::Migration
  def change
    create_table :article_extractions do |t|
      t.references :article, index: true, foreign_key: true, nil: false
      t.integer    :source, blank: false
    end
  end
end
