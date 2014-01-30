class CreateMeritActions < ActiveRecord::Migration
  def self.up
    create_table :merit_actions do |t|
      t.integer :user_id
      t.string  :action_method
      t.integer :action_value
      t.boolean :had_errors, default: false
      t.string  :target_model
      t.integer :target_id
      t.boolean :processed, default: false
      t.timestamps
    end
  end

  def self.down
    drop_table :merit_actions
  end
end
