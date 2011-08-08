class Badge < ActiveRecord::Base
  has_many :badges_sashes
  has_many :sashes, :through => :badges_sashes

  # Latest badges granted by Merit
  def self.latest(limit = 10)
    Badge.joins(:badges_sashes).order('badges_sashes.created_at DESC').limit(limit)
  end

  # Grant badge to sash
  def grant_to(sash)
    unless sash.badges.include? self
      sash.badges << self
      sash.save
    end
  end

  # Take out badge from sash
  def delete_from(sash)
    if sash.badges.include? self
      sash.badges -= [self]
      sash.save
    end
  end

  # Give rank to sash if it's greater. Delete lower ranks it may have.
  def grant_rank_to(sash)
    # Grant to sash if had lower rank. Do nothing if has same or greater rank.
    if sash.has_lower_rank_than(self)
      sash.badges -= Badge.where(:name => name) # Clean up old ranks
      sash.badges << self
      sash.save
    end
  end
end