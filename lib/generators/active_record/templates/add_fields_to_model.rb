class AddFieldsTo<%= table_name.camelize %> < ActiveRecord::Migration
  def change
    add_column :<%= table_name %>, :sash_id, :integer
    add_column :<%= table_name %>, :level,   :integer, :default => 0
  end
end
