class AddTargetDataToMeritActions < ActiveRecord::Migration[5.0]
  def change
    add_column :merit_actions, :target_data, :text
  end
end
