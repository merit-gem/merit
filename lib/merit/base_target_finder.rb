module Merit
  class BaseTargetFinder
    def self.find(*args)
      new(*args).find
    end

    def initialize(rule, action)
      @rule = rule
      @action = action
    end

    def find
      get_target_from_database || reanimate_target_from_action
    rescue => e
      Rails.logger.warn "[merit] no target found: #{e}. #{caller.first}"
    end

    def get_target_from_database
      model_class.find_by_id(@action.target_id)
    end

    def model_class
      klass_name = (@rule.model_name || @action.target_model).singularize
      klass_name.camelize.constantize
    end

    def reanimate_target_from_action
      if @action.respond_to? :target_data
        YAML.load(@action.target_data)
      else
        Merit.upgrade_target_data_warning
        nil
      end
    end
  end
end
