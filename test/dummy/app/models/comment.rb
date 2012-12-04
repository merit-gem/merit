class Comment < ActiveRecord::Base
  belongs_to :user

  attr_accessible :name, :comment, :user_id, :votes

  validates :name, :comment, :user_id, :presence => true

  def friend
    User.find_by_name('friend')
  end
end
