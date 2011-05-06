class User < ActiveRecord::Base
  has_many :comments
end
