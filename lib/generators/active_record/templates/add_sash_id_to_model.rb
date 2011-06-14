class AddSashIdTo<%= table_name.camelize %> < ActiveRecord::Migration
  def self.up
    add_column :<%= table_name %>, :sash_id, :integer
  end

  def self.down
    remove_column :<%= table_name %>, :sash_id
  end
end