class CreateTalentActions < ActiveRecord::Migration
  def self.up
    create_table :talent_actions do |t|
      t.integer :user_id # source
      t.string  :action_method
      t.integer :action_value
      t.string  :target_model
      t.integer :target_id
      t.timestamps
    end
  end
  
  def self.down
    drop_table :talent_actions
  end
end