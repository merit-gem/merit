module Merit
  class SashFinder
    def self.find(rule, action)
      targets(rule, action).map(&:_sash)
    end

    def self.targets(rule, action)
      TargetFinder.find(rule, action).compact
    end
  end
end
