class TalentCreateBadges<%= table_name.camelize %> < ActiveRecord::Migration
  def self.up
    create_table :badges_<%= table_name %>, :id => false do |t|
      t.integer :badge_id, :<%= file_path %>_id
      t.boolean :notified_user, :default => false
    end
  end

  def self.down
    drop_table :badges_<%= table_name %>
  end
end