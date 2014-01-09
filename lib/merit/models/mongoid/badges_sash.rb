#module Merit
  class BadgesSash
    include Mongoid::Document
    include Mongoid::Timestamps

    field :badge_id,      type: Integer #??? check this

    attr_accessible :badge_id

    belongs_to :sash
    has_many :activity_logs, class_name: 'ActivityLog', as: :related_change

    def self.last_granted(options = {})
      options[:since_date] ||= 1.month.ago
      options[:limit]      ||= 10
      where(:created_at.lte => options[:since_date]).
        limit(options[:limit]).
        map(&:badge)
    end

    def badge
      Badge.find(badge_id)
    end
  end
#end
