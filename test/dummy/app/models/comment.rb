class Comment < ActiveRecord::Base
  belongs_to :user
  validates :name, :comment, :user_id, :presence => true
end
