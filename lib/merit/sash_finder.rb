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
      targets.map do |target|
        target.try(:_sash)
      end.compact
    end

    private

    def targets
      @targets ||= TargetFinder.find(@rule, @action)
    end

  end
end
