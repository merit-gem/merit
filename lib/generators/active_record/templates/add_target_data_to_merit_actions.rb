class AddTargetDataToMeritActions < ActiveRecord::Migration<%= migration_version %>
  def change
    add_column :merit_actions, :target_data, :text
  end
end
