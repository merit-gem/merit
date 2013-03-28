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
      @sashes.each { |sash| apply_points_to sash }
    end

    private

    def apply_badge_to(sash)
      BadgeJudge.judge sash, @rule, @action
    end

    def apply_points_to(sash)
      PointJudge.judge sash, @rule, @action
    end

  end
end
