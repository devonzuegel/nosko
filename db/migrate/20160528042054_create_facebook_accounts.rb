class CreateFacebookAccounts < ActiveRecord::Migration
  def change
    create_table :facebook_accounts do |t|
      t.string :auth_token
      t.integer :expires_at
      t.string :email
      t.string :fb_id
      t.string :name
      t.string :image
      t.string :uid

      t.timestamps null: false
    end
  end
end
