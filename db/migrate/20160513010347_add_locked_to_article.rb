class AddLockedToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :locked, :boolean, default: false
  end
end
