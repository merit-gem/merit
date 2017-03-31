class CreateSashes < ActiveRecord::Migration
  def self.up
    create_table :sashes do |t|
      t.timestamps null: false
    end
  end

  def self.down
    drop_table :sashes
  end
end
