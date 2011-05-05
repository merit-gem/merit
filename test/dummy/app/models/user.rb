class User < ActiveRecord::Base
  has_many :comments
  has_many :badges_users
  has_many :badges, :through => :badges_users
end
