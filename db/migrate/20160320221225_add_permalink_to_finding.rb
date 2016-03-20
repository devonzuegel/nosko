class AddPermalinkToFinding < ActiveRecord::Migration
  def change
    add_column :findings, :permalink, :string
  end
end
