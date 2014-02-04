case ENV['ORM']
when 'active_record'
  class Comment < ActiveRecord::Base
  end
when 'mongoid'
  class Comment
    include Mongoid::Document
    include Mongoid::Timestamps

    field :name, :type => String
    field :comment, :type => String
    field :votes, :type => Integer
  end
end

class Comment
  has_merit

  belongs_to :user

  if defined?(ProtectedAttributes) || !defined?(ActionController::StrongParameters)
    attr_accessible :name, :comment, :user_id, :votes
  end

  validates :name, :comment, :user_id, :presence => true

  delegate :comments, :to => :user, :prefix => true

  def friend
    User.find_by_name('friend')
  end
end
