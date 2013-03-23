module Merit
  class SashFinder

    def self.find(*args)
      self.new(*args).find
    end

    def initialize(rule, action)
      @rule = rule
      @action = action
    end

    def find
      target.try(:_sash)
    end

    private

    def target
      @target ||= TargetFinder.find(@rule, @action)
    end

  end
end
