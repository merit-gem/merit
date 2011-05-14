class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.string  :name
      t.text    :comment
      t.integer :user_id
      t.integer :votes, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
