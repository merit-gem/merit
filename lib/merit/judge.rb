module Merit
  class Judge
    def initialize(sash, rule, options = {})
      @sash = sash
      @rule = rule
      # FIXME: Too much context:
      # A Judge should apply reputation independently of the action
      @action = options[:action]
    end

    # Grant badge if rule applies. If it doesn't, and the badge is temporary,
    # then remove it.
    def apply_badges
      if rule_applies?
        if badge.grant_to(@sash, :allow_multiple => @rule.multiple)
          to_action_user = (@rule.to.to_sym == :action_user ? '_to_action_user' : '')
          @action.log_activity "badge_granted#{to_action_user}:#{badge.id}"
        end
      elsif @rule.temporary
        if badge.delete_from(@sash)
          @action.log_activity "badge_removed:#{badge.id}"
        end
      end
    end

    def apply_points
      return unless rule_applies?
      @sash.add_points @rule.score, @action.inspect[0..240]
      @action.log_activity "points_granted:#{@rule.score}"
    end

    private

    # FIXME: Too tightly coupled three objects
    def rule_applies?
      @rule.applies? @action.target_object(@rule.model_name)
    end

    def badge
      @rule.badge
    end
  end
end
