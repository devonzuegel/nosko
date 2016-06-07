class AddFavoritedToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :favorited, :boolean, default: false
  end
end
