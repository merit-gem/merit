class Sash < ActiveRecord::Base
  has_many :badges_sashes
  has_many :badges, :through => :badges_sashes

  def add_badge(badge_id)
    BadgesSash.create(sash: self, badge_id: badge_id)
  end
  def rm_badge(badge_id)
    ActiveRecord::Base.connection.execute("DELETE FROM badges_sashes
      WHERE badge_id = #{badge_id} AND sash_id = #{self.id}")
  end
end
