class User < ActiveRecord::Base
  has_many :comments

  def show_badges
    self.badges.collect{|b| "#{b.name.capitalize} (#{b.level})" }.join(', ')
  end
end
