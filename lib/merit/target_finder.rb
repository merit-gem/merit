module Merit
  class TargetFinder

    def self.find(*args)
      self.new(*args).find
    end

    def initialize(rule, action)
      @rule = rule
      @action = action
    end

    def find
      case @rule.to
      when :itself; original_target
      when :action_user; action_user
      else; other_target
      end
    end

    private

    def original_target
      klass_name = (@rule.model_name || @action.target_model).singularize
      klass = klass_name.camelize.constantize
      klass.find_by_id @action.target_id
    end

    def action_user
      user = Merit.user_model.find_by_id(@action.user_id)
      unless user
        user_id = @action.user_id
        user_model = Merit.user_model
        message = "[merit] no #{user_model} found with id #{user_id}"
        Rails.logger.warn message
      end
      user
    end

    def other_target
      original_target.send(@rule.to)
    rescue NoMethodError
      message = "[merit] NoMethodError on"
      message << " `#{original_target.class.name}##{@rule.to}`"
      message << " (called from Merit::TargetFinder#other_target)"
      Rails.logger.warn message
    end

  end
end
