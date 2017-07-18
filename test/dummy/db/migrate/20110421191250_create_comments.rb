class CreateComments < ActiveRecord::Migration[5.0]
  def self.up
    create_table :comments do |t|
      t.string  :name
      t.text    :comment
      t.integer :user_id
      t.integer :votes, :default => 0

      t.timestamps null: false
    end
  end

  def self.down
    drop_table :comments
  end
end
