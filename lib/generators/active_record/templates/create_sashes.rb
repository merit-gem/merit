class CreateSashes < ActiveRecord::Migration<%= migration_version %>
  def change
    create_table :sashes do |t|
      t.timestamps null: false
    end
  end
end
