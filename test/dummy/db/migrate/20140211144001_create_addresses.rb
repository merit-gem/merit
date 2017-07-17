class CreateAddresses < ActiveRecord::Migration[5.0]
  def up
    create_table :addresses do |t|
      t.references :user
    end
  end

  def down
    drop_table :addresses
  end
end
