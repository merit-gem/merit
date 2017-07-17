class CreatePlayers < ActiveRecord::Migration[5.0]
  def change
    create_table :players do |t|
      t.integer :sash_id
      t.integer :level, default: 0
    end
  end
end
