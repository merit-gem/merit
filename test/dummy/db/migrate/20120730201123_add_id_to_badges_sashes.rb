class AddIdToBadgesSashes < ActiveRecord::Migration
  def self.up
    add_column :badges_sashes, :id, :primary_key
  end

  def self.down
    remove_column :badges_sashes, :id
  end
end
