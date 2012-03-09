require "merit/models/#{Merit.orm}/sash"

class Sash
  # Decides if sash has lower rank than a given badge
  def has_lower_rank_than(badge)
    badges = Badge.find_by_id(badge_ids)
    levels = badges.by_name(badge.name).collect(&:level)
    levels.all_lower_than badge.level
  end
end
