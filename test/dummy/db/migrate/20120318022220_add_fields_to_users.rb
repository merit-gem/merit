class AddFieldsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :sash_id, :integer
    add_column :users, :points, :integer, :default => 0
    add_column :users, :level, :integer, :default => 0
    User.all.each{|user| user.update_attribute(:points, 0) } # Update existing entries
  end

  def self.down
    remove_column :users, :sash_id
    remove_column :users, :points
    remove_column :users, :level
  end
end