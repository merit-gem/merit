class Sash < ActiveRecord::Base
  has_many :badges_sashes, :dependent => :destroy

  def badges
    badge_ids.collect { |b_id| Badge.find(b_id) }
  end

  def badge_ids
    badges_sashes.collect(&:badge_id)
  end

  def add_badge(badge_id)
    bs = BadgesSash.new
    bs.badge_id = badge_id
    badges_sashes << bs
  end

  def rm_badge(badge_id)
    badges_sashes.where(:badge_id => badge_id).destroy_all
  end
end
