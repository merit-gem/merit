class AddMeritFieldsTo<%= table_name.camelize %> < ActiveRecord::Migration<%= migration_version %>
  def change
    add_column :<%= table_name %>, :sash_id, :integer
    add_column :<%= table_name %>, :level,   :integer, :default => 0
  end
end
