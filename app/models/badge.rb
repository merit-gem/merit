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
      ids = Array.wrap(ids)
      find{|b| ids.include? b[:id] }
    end
    def by_name(name)
      find{|b| b.name == name.to_s }
    end
    def by_level(level)
      find{|b| b.level.to_s == level.to_s }
    end
  end

  # Grant badge to sash
  # Accepts :allow_multiple boolean option, defaults to false
  def grant_to(object_or_sash, *args)
    options = args.extract_options!
    options[:allow_multiple] ||= false
    sash = sash(object_or_sash)

    if !sash.badge_ids.include?(id) || options[:allow_multiple]
      sash.add_badge(id)
      return true
    else
      return false
    end
  end

  # Take out badge from sash
  def delete_from(object_or_sash)
    sash = sash(object_or_sash)
    if sash.badge_ids.include?(id)
      sash.rm_badge(id)
      return true
    else
      return false
    end
  end

  def sash(object_or_sash)
    if object_or_sash.kind_of?(Sash)
      object_or_sash
    else
      object_or_sash.sash || object_or_sash.create_sash_and_scores
    end
  end
end
