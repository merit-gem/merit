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
    def find_by_name(name)
      by_name(name).first
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
    object_or_sash.create_sash_if_none unless object_or_sash.kind_of?(Sash)
    sash = object_or_sash.respond_to?(:sash) ? object_or_sash.sash : object_or_sash

    options = args.extract_options!
    options[:allow_multiple] ||= false

    if !sash.badge_ids.include?(id) || options[:allow_multiple]
      sash.add_badge(id)
      return true
    else
      return false
    end
  end

  # Take out badge from sash
  def delete_from(object_or_sash)
    object_or_sash.create_sash_if_none unless object_or_sash.kind_of?(Sash)
    sash = object_or_sash.respond_to?(:sash) ? object_or_sash.sash : object_or_sash
    if sash.badge_ids.include?(id)
      sash.rm_badge(id)
      return true
    else
      return false
    end
  end
end
