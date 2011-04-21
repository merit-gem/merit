class CreateBadges < ActiveRecord::Migration
  def self.up
    create_table :badges do |t|
      t.string :name
      t.string :level
      t.string :image
      t.string :description
      t.timestamps
    end

    # First badge
    Badge.create( :name => 'just', :level => 'registered' ) # just-did-something
    Badge.create( :name => 'creator', :level => 'inspired', :image => 'http://upload.wikimedia.org/wikipedia/commons/9/94/Luca_prodan.jpg' )
  end

  def self.down
    drop_table :badges
  end
end