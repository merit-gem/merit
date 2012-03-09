class Badge
  # Grant badge to sash
  def grant_to(object_or_sash)
    object_or_sash.create_sash_if_none unless object_or_sash.kind_of?(Sash)
    sash = object_or_sash.respond_to?(:sash) ? object_or_sash.sash : object_or_sash
    unless sash.badges.include? self
      sash.badges << self
      sash.save
    end
  end

  # Take out badge from sash
  def delete_from(object_or_sash)
    object_or_sash.create_sash_if_none unless object_or_sash.kind_of?(Sash)
    sash = object_or_sash.respond_to?(:sash) ? object_or_sash.sash : object_or_sash
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

  def self.latest(limit = nil)
    scope = order('created_at DESC')
    limit.present? ? scope.limit(limit) : scope
  end
end
