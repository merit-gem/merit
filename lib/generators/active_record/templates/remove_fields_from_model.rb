class RemoveFieldsFrom<%= table_name.camelize %> < ActiveRecord::Migration
  def self.up
    remove_column :<%= table_name %>, :sash_id
    remove_column :<%= table_name %>, :level
  end
end
