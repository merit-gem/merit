class CreateMeritActions < ActiveRecord::Migration
  def change
    create_table :merit_actions do |t|
      t.integer :user_id
      t.string  :action_method
      t.integer :action_value
      t.boolean :had_errors, default: false
      t.string  :target_model
      t.integer :target_id
      t.text    :target_data
      t.boolean :processed, default: false
      t.timestamps
    end
  end
end
