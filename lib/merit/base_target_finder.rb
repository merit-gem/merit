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
      parse_target_data(@action.target_data)
    end

    private

    def parse_target_data(target_data)
      model_class.new JSON.parse(target_data)
    rescue JSON::ParserError
      YAML.safe_load(
        target_data,
        permitted_classes: Merit.yaml_safe_load_permitted_classes,
        aliases: false
      )
    end
  end
end
