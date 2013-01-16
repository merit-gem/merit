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

  def self.find_by_name_and_level(name, level)
    badges = Badge.by_name(name)
    badges = badges.by_level(level) unless level.nil?
    if !(badge = badges.first)
      raise ::Merit::BadgeNotFound, "No badge '#{name}'#{level.nil? ? '' : " with level #{level}"} found. Define it in 'config/initializers/merit.rb'."
    end
    badge
  end

  # Last badges granted
  def self.last_granted(options = {})
    options[:since_date] ||= 1.month.ago
    options[:limit]      ||= 10
    BadgesSash.last_granted(options)
  end
end
