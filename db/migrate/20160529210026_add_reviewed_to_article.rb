class AddReviewedToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :reviewed, :boolean, default: false, null: false
  end
end
