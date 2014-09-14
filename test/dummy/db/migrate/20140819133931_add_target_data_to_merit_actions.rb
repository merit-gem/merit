class AddTargetDataToMeritActions < ActiveRecord::Migration
  def change
    add_column :merit_actions, :target_data, :text
  end
end
