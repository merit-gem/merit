module Merit
  require 'ambry'
  require 'ambry/active_model'

  class Badge
    extend Ambry::Model
    extend Ambry::ActiveModel

    field :id, :name, :level, :description, :custom_fields

    validates_presence_of :id, :name
    validates_uniqueness_of :id

    filters do
      def find_by_id(ids)
        ids = Array.wrap(ids)
        find { |b| ids.include? b[:id] }
      end

      def by_name(name)
        find { |b| b.name.to_s == name.to_s }
      end

      def by_level(level)
        find { |b| b.level.to_s == level.to_s }
      end
    end

    def _mongoid_sash_in(sashes)
      {:sash_id.in => sashes}
    end

    def _active_record_sash_in(sashes)
      {sash_id: sashes}
    end

    class << self
      def find_by_name_and_level(name, level)
        badges = Merit::Badge.by_name(name)
        badges = badges.by_level(level) unless level.nil?
        if (badge = badges.first).nil?
          str = "No badge '#{name}' found. Define it in initializers/merit.rb"
          fail ::Merit::BadgeNotFound, str
        end
        badge
      end

      # Defines Badge#meritable_models method, to get related
      # entries with certain badge. For instance, Badge.find(3).users
      # orm-specified
      def _define_related_entries_method(meritable_class_name)
        define_method(:"#{meritable_class_name.underscore.pluralize}") do
          sashes = BadgesSash.where(badge_id: id).pluck(:sash_id)
          meritable_class_name.constantize.where(send "_#{Merit.orm}_sash_in", sashes)
        end
      end
    end
  end
end
