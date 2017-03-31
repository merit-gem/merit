class CreateSashes < ActiveRecord::Migration
  def change
    create_table :sashes do |t|
      t.timestamps null: false
    end
  end
end
