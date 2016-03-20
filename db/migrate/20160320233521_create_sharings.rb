class CreateSharings < ActiveRecord::Migration
  def change
    create_table :sharings do |t|
      t.boolean :share_by_default
      t.string :reminders_frequency
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
