class Sash < ActiveRecord::Base
  has_many :badges_sashes

  def badge_ids
    badges_sashes.collect(&:badge_id)
  end

  def add_badge(badge_id)
    BadgesSash.create(sash_id: self.id, badge_id: badge_id)
  end
  def rm_badge(badge_id)
    ActiveRecord::Base.connection.execute("DELETE FROM badges_sashes
      WHERE badge_id = #{badge_id} AND sash_id = #{self.id}")
  end
end
