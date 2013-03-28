module Merit
  module RuleEvaluator

    def rule_applies?
      @rule.applies? target
    end

    def target
      @target ||= BaseTargetFinder.find(@rule, @action)
    end

  end
end
