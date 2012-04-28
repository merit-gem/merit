class User < ActiveRecord::Base
  has_merit

  has_many :comments

  attr_accessible :name

  def show_badges
    badges.collect{|b| "#{b.name.capitalize} (#{b.level})" }.join(', ')
  end
end
