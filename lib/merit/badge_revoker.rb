module Merit
  class BadgeRevoker

    def self.revoke(*args)
      self.new(*args).revoke
    end

    def initialize(sash, badge, action)
      @sash = sash
      @badge = badge
      @action = action
    end

    def revoke
      @sash.rm_badge @badge.id
      @action.log_activity log_message
    end

    private

    def log_message
      "badge_removed:#{@badge.id}"
    end

  end
end
