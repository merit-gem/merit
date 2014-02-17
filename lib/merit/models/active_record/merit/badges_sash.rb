module Merit
  class BadgesSash < ActiveRecord::Base
    include Base::BadgesSash
    has_many :activity_logs,
             class_name: Merit::ActivityLog,
             as: :related_change

    if defined?(ProtectedAttributes) || !defined?(ActionController::StrongParameters)
      attr_accessible :badge_id
    end

    # DEPRECATED: `last_granted` will be removed from merit, please refer to:
    # https://github.com/tute/merit/wiki/How-to-show-last-granted-badges
    def self.last_granted(options = {})
      warn '[DEPRECATION] `last_granted` will be removed from merit, please refer to: https://github.com/tute/merit/wiki/How-to-show-last-granted-badges'
      options[:since_date] ||= 1.month.ago
      options[:limit]      ||= 10
      where("created_at > '#{options[:since_date]}'")
        .limit(options[:limit])
        .map(&:badge)
    end
  end
end
