module Merit
  class PointJudge
    include RuleEvaluator

    def self.judge(*args)
      self.new(*args).judge
    end

    def initialize(sash, rule, action)
      @sash = sash
      @rule = rule
      @action = action
    end

    def judge
      return unless rule_applies?
      @sash.add_points @rule.score, @action.inspect[0..240]
      @action.log_activity "points_granted:#{@rule.score}"
    end

  end
end
