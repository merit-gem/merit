class User
  include Mongoid::Document
  include Mongoid::Timestamps

  has_merit

  field :name

  has_many :comments

  attr_accessible :name

  def self.find_by_id(id)
    where(:_id => id).first
  end

  def show_badges
    create_sash_if_none
    badges_uniq = Badge.find_by_id(sash.badge_ids)
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
