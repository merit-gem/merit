class Sash
  include MongoMapper::Document

  key :badge_ids, Array
  timestamps!

  def add_badge(badge_id)
    self.badge_ids << badge_id
    self.save
  end
  def rm_badge(badge_id)
    self.badge_ids -= [badge_id]
    self.save
  end
end
