class AddVisibilityToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :visibility, :integer, default: 0
  end
end
