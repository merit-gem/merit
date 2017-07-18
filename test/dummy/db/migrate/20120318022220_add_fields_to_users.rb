class AddFieldsToUsers < ActiveRecord::Migration[5.0]
  def self.up
    add_column :users, :sash_id, :integer
    add_column :users, :level, :integer, :default => 0
  end

  def self.down
    remove_column :users, :sash_id
    remove_column :users, :level
  end
end
