module Merit
  class Judge
    def initialize(sashes, rule, options = {})
      @sashes = sashes
      @rule = rule
      # FIXME: Too much context:
      # A Judge should apply reputation independently of the action
      @action = options[:action]
    end

    def apply_badges
      @sashes.each { |sash| apply_badge_to sash }
    end

    def apply_points
      return unless rule_applies?
      @sashes.each do |sash|
        sash.add_points @rule.score, @action.inspect[0..240]
      end
      @action.log_activity "points_granted:#{@rule.score}"
    end

    private

    def apply_badge_to(sash)
      BadgeJudge.judge sash, @rule, @action
    end

    def rule_applies?
      @rule.applies? target
    end

    def target
      @target ||= BaseTargetFinder.find(@rule, @action)
    end

  end
end
