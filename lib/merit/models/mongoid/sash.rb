class Sash
  include Mongoid::Document
  include Mongoid::Timestamps

  field :badge_ids, :type => Array, :default => []

  def add_badge(badge_id)
    self.push(:badge_ids, badge_id)
  end

  def rm_badge(badge_id)
    self.pull(:badge_ids, badge_id)
  end
end
