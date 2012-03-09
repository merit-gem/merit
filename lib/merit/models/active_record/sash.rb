class Sash < ActiveRecord::Base
  has_many :badges_sashes
  has_many :badges, :through => :badges_sashes

  # Latest badges granted by Merit
  def self.latest_badges(limit = 10)
    select('DISTINCT sashes.id, sashes.*').joins(:badges_sashes).order('badges_sashes.created_at DESC').limit(limit)
  end
end
