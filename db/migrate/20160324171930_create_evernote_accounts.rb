class CreateEvernoteAccounts < ActiveRecord::Migration
  def change
    create_table :evernote_accounts do |t|
      t.string     :auth_token
      t.datetime   :last_accessed_at
      t.references :user, index: true, foreign_key: true
    end
  end
end
