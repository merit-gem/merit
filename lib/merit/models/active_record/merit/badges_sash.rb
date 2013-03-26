module Merit
  class BadgesSash < ActiveRecord::Base
    belongs_to :sash

    def self.last_granted(options = {})
      options[:since_date] ||= 1.month.ago
      options[:limit]      ||= 10
      where("created_at > '#{options[:since_date]}'").
        limit(options[:limit]).
        map(&:badge)
    end

    def badge
      Badge.find(badge_id)
    end
  end
end
