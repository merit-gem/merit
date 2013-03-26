module Merit
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

    class << self
      def find_by_name_and_level(name, level)
        badges = Badge.by_name(name)
        badges = badges.by_level(level) unless level.nil?
        if !(badge = badges.first)
          raise ::Merit::BadgeNotFound, "No badge '#{name}'#{level.nil? ? '' : " with level #{level}"} found. Define it in 'config/initializers/merit.rb'."
        end
        badge
      end

      # Last badges granted
      def last_granted(options = {})
        options[:since_date] ||= 1.month.ago
        options[:limit]      ||= 10
        BadgesSash.last_granted(options)
      end

      # Defines Badge#meritable_models method, to get related
      # entries with certain badge. For instance, Badge.find(3).users
      def _define_related_entries_method(meritable_class_name)
        define_method(:"#{meritable_class_name.underscore.pluralize}") do
          sashes = BadgesSash.where(badge_id: self.id).pluck(:sash_id)
          meritable_class_name.constantize.where(sash_id: sashes)
        end
      end
    end
  end
end
