case Merit.orm
when :active_record
  class Comment < ActiveRecord::Base
    def friend
      User.find_by_name('friend')
    end
  end
when :mongoid
  class Comment
    include Mongoid::Document
    include Mongoid::Timestamps

    field :name, :type => String
    field :comment, :type => String
    field :votes, :type => Integer, :default => 0

    def friend
      User.find_by(name: 'friend')
    end
  end
end

class Comment
  has_merit

  belongs_to :user

  validates :name, :comment, :user_id, :presence => true

  delegate :comments, :to => :user, :prefix => true
end
