class Sash < ActiveRecord::Base
  has_many :badges_sashes

  def badge_ids
    badges_sashes.collect(&:badge_id)
  end

  def add_badge(badge_id)
    BadgesSash.create(sash_id: self.id, badge_id: badge_id)
  end
  def rm_badge(badge_id)
    badges_sashes = BadgesSash.where(:badge_id => badge_id, :sash_id => self.id)
    # ActiveRecord::Relation#delete doesn't work with composite keys.
    # Badge is not AR model (Ambry) so can't do self.badges.find(badge_id).delete
    badges_sash = badges_sashes.first
    badges_sashes.delete_all
    # delete doesn't run callbacks, do it by hand
    if Object.const_defined?('BadgesSashObserver')
      BadgesSashObserver.instance.after_delete(badges_sash)
    end
  end
end
