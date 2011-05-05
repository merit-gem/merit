class CreateBadgesUsers < ActiveRecord::Migration
  def self.up
    create_table :badges_users, :id => false do |t|
      t.integer :badge_id, :user_id
      t.boolean :notified_user, :default => false
    end
  end

  def self.down
    drop_table :badges_users
  end
end