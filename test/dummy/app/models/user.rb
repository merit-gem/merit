class User < ActiveRecord::Base
  merit
  has_many :comments

  def show_badges
    badges.collect{|b| "#{b.name.capitalize} (#{b.level})" }.join(', ')
  end
end
