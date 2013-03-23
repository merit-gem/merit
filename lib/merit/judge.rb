module Merit
  class Judge
    def initialize(sashes, rule, options = {})
      @sashes = sashes
      @rule = rule
      # FIXME: Too much context:
      # A Judge should apply reputation independently of the action
      @action = options[:action]
    end

    # Grant badge if rule applies. If it doesn't, and the badge is temporary,
    # then remove it.
    def apply_badges
      if rule_applies?
        grant_badge if new_or_multiple?
      else
        remove_badge if @rule.temporary
      end
    end

    def apply_points
      return unless rule_applies?
      @sashes.each do |sash|
        sash.add_points @rule.score, @action.inspect[0..240]
      end
      @action.log_activity "points_granted:#{@rule.score}"
    end

    private

    def grant_badge
      @sashes.each do |sash|
        sash.add_badge(badge.id)
      end
      to_action_user = (@rule.to.to_sym == :action_user ? '_to_action_user' : '')
      @action.log_activity "badge_granted#{to_action_user}:#{badge.id}"
    end

    def remove_badge
      @sashes.each do |sash|
        sash.rm_badge(badge.id)
      end
      @action.log_activity "badge_removed:#{badge.id}"
    end

    def new_or_multiple?
      !@sashes.map(&:badge_ids).include?(badge.id) || @rule.multiple
    end

    def rule_applies?
      @rule.applies? target
    end

    def target
      @target ||= BaseTargetFinder.find(@rule, @action)
    end

    def badge
      @rule.badge
    end
  end
end
