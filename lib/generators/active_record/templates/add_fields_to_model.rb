class AddFieldsTo<%= table_name.camelize %> < ActiveRecord::Migration
  def self.up
    add_column :<%= table_name %>, :sash_id, :integer
    add_column :<%= table_name %>, :level, :integer, :default => 0
    <%- resource = table_name.singularize -%>
  end

  def self.down
    remove_column :<%= table_name %>, :sash_id
    remove_column :<%= table_name %>, :level
  end
end
