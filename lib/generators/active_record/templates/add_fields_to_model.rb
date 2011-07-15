class AddFieldsTo<%= table_name.camelize %> < ActiveRecord::Migration
  def self.up
    add_column :<%= table_name %>, :sash_id, :integer
    add_column :<%= table_name %>, :points, :integer, :default => 0
    <%- resource = table_name.singularize -%>
    <%= resource.camelize %>.all.each{|<%= resource %>| <%= resource %>.update_attribute(:points, 0) } # Update existing entries
  end

  def self.down
    remove_column :<%= table_name %>, :sash_id
    remove_column :<%= table_name %>, :points
  end
end