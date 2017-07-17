class CreateMeritActivityLogs < ActiveRecord::Migration[5.0]
  def self.up
    create_table :merit_activity_logs do |t|
      t.integer  :action_id
      t.string   :related_change_type
      t.integer  :related_change_id
      t.string   :description
      t.datetime :created_at
    end
  end

  def self.down
    drop_table :merit_activity_logs
  end
end
