class CreateFriendships < ActiveRecord::Migration
  def change
    create_table :friendships do |t|
      t.references :friender, references: :users, null: false, index: true
      t.references :friendee, references: :users, null: false, index: true
      t.boolean    :confirmed, default: false, null: false

      t.timestamps null: false
    end
  end
end
