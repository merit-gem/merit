class CreateSashes < ActiveRecord::Migration[5.0]
  def self.up
    create_table :sashes do |t|
      t.timestamps null: false
    end
  end

  def self.down
    drop_table :sashes
  end
end
