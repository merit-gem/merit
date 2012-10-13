class CreateScoresAndPoints < ActiveRecord::Migration
  def self.up
    create_table :merit_scores do |t|
      t.references :sash
      t.string :category, :default => 'default'
    end

    create_table :merit_scores_points do |t|
      t.references :score
      t.integer :num_points, :default => 0
      t.string :log
    end
  end

  def self.down
    drop_table :merit_scores
    drop_table :merit_scores_points
  end
end
