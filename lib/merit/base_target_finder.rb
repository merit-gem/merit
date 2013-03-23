module Merit
  class BaseTargetFinder

    def self.find(*args)
      self.new(*args).find
    end

    def initialize(rule, action)
      @rule = rule
      @action = action
    end

    def find
      klass_name = (@rule.model_name || @action.target_model).singularize
      klass = klass_name.camelize.constantize
      klass.find_by_id @action.target_id
    rescue => e
      Rails.logger.warn "[merit] no target found: #{e}. #{caller.first}"
    end

  end
end
