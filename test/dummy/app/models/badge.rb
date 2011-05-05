class Badge < ActiveRecord::Base
  has_many :badges_users
  has_many :users, :through => :badges_users
end
