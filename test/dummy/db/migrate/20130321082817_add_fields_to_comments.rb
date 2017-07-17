class AddFieldsToComments < ActiveRecord::Migration[5.0]
  def self.up
    add_column :comments, :sash_id, :integer
    add_column :comments, :level, :integer, :default => 0
  end

  def self.down
    remove_column :comments, :sash_id
    remove_column :comments, :level
  end
end
