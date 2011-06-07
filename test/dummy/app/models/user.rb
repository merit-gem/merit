class User < ActiveRecord::Base
  has_many :badges_users
  has_many :badges, :through => :badges_users

  has_many :comments

  def show_badges
    badges.collect{|b| "#{b.name.capitalize} (#{b.level})" }.join(', ')
  end
end
