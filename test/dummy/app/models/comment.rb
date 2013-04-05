class Comment < ActiveRecord::Base
  has_merit

  belongs_to :user

  if Rails.version < '4'
    attr_accessible :name, :comment, :user_id, :votes
  end

  validates :name, :comment, :user_id, :presence => true

  delegate :comments, :to => :user, :prefix => true

  def friend
    User.find_by_name('friend')
  end
end
