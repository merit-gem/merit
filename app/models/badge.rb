require 'ambry'
require 'ambry/active_model'

class Badge
  extend Ambry::Model
  extend Ambry::ActiveModel

  field :id, :name, :level, :image, :description

  validates_presence_of :id, :name
  validates_uniqueness_of :id

  filters do
    def find_by_id(ids)
      ids = ids.kind_of?(Array) ? ids : [ids]
      find{|b| ids.include? b.id }
    end
    def by_name(name)
      find{|b| b.name == name.to_s }
    end
    def by_level(level)
      find{|b| b.level.to_s == level.to_s }
    end
  end

  # Grant badge to sash
  def grant_to(object_or_sash)
    object_or_sash.create_sash_if_none unless object_or_sash.kind_of?(Sash)
    sash = object_or_sash.respond_to?(:sash) ? object_or_sash.sash : object_or_sash
    sash.add_badge(id) unless sash.badge_ids.include?(id)
  end

  # Take out badge from sash
  def delete_from(object_or_sash)
    object_or_sash.create_sash_if_none unless object_or_sash.kind_of?(Sash)
    sash = object_or_sash.respond_to?(:sash) ? object_or_sash.sash : object_or_sash
    sash.rm_badge(id) if sash.badge_ids.include?(id)
  end

  # Give rank to sash if it's greater. Delete lower ranks it may have.
  def grant_rank_to(sash)
    # Grant to sash if had lower rank. Do nothing if has same or greater rank.
    if sash.has_lower_rank_than(self)
      Badge.by_name(name).keys.each{|id| sash.rm_badge(id) } # Clean up old ranks
      sash.add_badge(id)
    end
  end
end
