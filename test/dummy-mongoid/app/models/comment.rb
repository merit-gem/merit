class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :user

  field :name
  field :comment
  field :votes, :type => Integer, :default => 0

  attr_accessible :name, :comment, :user_id, :votes

  validates :name, :comment, :user_id, :presence => true
end
