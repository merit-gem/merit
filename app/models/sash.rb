class Sash
  # Decides if sash has lower rank than a given badge
  def has_lower_rank_than(badge)
    levels(badge.name).all_lower_than badge.level
  end

  # Collect Sash levels given a badge name
  def levels(badge_name)
    badges.where(:name => badge_name).collect(&:level)
  end
end
