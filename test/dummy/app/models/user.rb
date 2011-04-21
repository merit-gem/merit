class User < ActiveRecord::Base
  has_many :comments
  has_and_belongs_to_many :badges
end
