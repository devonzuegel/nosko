class CreateFollowings < ActiveRecord::Migration
  def change
    create_table :followings do |t|
      t.references :leader,   references: :users, null: false, index: true
      t.references :follower, references: :users, null: false, index: true
      t.timestamp  :unfollowed_at

      t.timestamps null: false
    end
  end
end
