class User < ActiveRecord::Base
  has_merit

  has_many :comments

  attr_accessible :name

  def show_badges
    badges_uniq = Badge.find_by_id(badge_ids)
    badges_uniq.collect{|b| "#{b.name.capitalize}#{badge_status(b)}" }.join(', ')
  end

  def badge_status(badge)
    status = []
    count = badges.select{|b| b.name == badge.name }.count
    status << "level: #{badge.level}" if badge.level
    status << "x#{count}" if count > 1
    status.present? ? " (#{status.join(', ')})" : ''
  end
end
