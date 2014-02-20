require File.expand_path("../../../base/sash", __FILE__)
require File.expand_path("../../../base/badges_sash", __FILE__)

module Merit
  class BadgesSash
    include Mongoid::Document
    include Mongoid::Timestamps
    include Base::BadgesSash

    field :badge_id,      type: Integer

    if defined?(ProtectedAttributes) || !defined?(ActionController::StrongParameters)
      attr_accessible :badge_id
    end

    has_many :activity_logs, class_name: 'Merit::ActivityLog', as: :related_change

    def self.last_granted(options = {})
      options[:since_date] ||= 1.month.ago
      options[:limit]      ||= 10
      where(:created_at.lte => options[:since_date])
        .limit(options[:limit])
        .map(&:badge)
    end
  end
end
