module Merit
  class SashFinder
    def self.find(rule, action)
      targets(rule, action).map(&:_sash)
    rescue NoMethodError
      Rails.logger.warn "[merit] Couldn't find model to grant reputation to. " \
                        "Refer to https://github.com/tute/merit/issues/171#issuecomment-44185696."
      []
    end

    def self.targets(rule, action)
      TargetFinder.find(rule, action).compact
    end
  end
end
