class Badge < ActiveRecord::Base
  has_many :badges_sashes
  has_many :sashes, :through => :badges_sashes

  def grant_to(sash)
    unless sash.badges.include? self
      sash.badges << self
      sash.save
    end
  end

  def grant_rank_to(sash)
    # Grant to sash if had lower rank. Do nothing if has same or greater rank.
    if sash.has_lower_rank_than(self)
      sash.badges -= Badge.where(:name => name) # Clean up old ranks
      sash.badges << self
      sash.save
    end
  end
end