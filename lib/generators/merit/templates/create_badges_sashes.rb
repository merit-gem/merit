class CreateBadgesSashes < ActiveRecord::Migration
  def self.up
    create_table :badges_sashes, :id => false do |t|
      t.integer :badge_id, :sash_id
      t.boolean :notified_user, :default => false
    end
  end

  def self.down
    drop_table :badges_sashes
  end
end