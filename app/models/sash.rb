class Sash < ActiveRecord::Base
  has_many :badges_sashes
  has_many :badges, :through => :badges_sashes

  # Latest badges granted by Merit
  def self.latest_badges(limit = 10)
    select('DISTINCT sashes.id, sashes.*').joins(:badges_sashes).order('badges_sashes.created_at DESC').limit(limit)
  end

  # Decides if sash has lower rank than a given badge
  def has_lower_rank_than(badge)
    levels(badge.name).all_lower_than badge.level
  end

  # Collect Sash levels given a badge name
  def levels(badge_name)
    badges.where(:name => badge_name).collect(&:level)
  end
end
