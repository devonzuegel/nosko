class CreateFindings < ActiveRecord::Migration
  def change
    create_table :findings do |t|
      t.string :url
      t.string :title
      t.string :kind

      t.timestamps null: false
    end
  end
end
