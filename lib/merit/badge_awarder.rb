module Merit
  class BadgeAwarder

    def self.award(*args)
      self.new(*args).award
    end

    def initialize(sash, rule, action)
      @sash = sash
      @rule = rule
      @action = action
    end

    def award
      @sash.add_badge badge.id
      to_action_user = (@rule.to.to_sym == :action_user ? '_to_action_user' : '')
      @action.log_activity "badge_granted#{to_action_user}:#{badge.id}"
    end

    private

    def badge
      @rule.badge
    end

  end
end
