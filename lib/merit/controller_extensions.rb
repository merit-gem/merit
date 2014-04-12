module Merit
  # Sets up an app-wide after_filter, and inserts merit_action entries if
  # there are defined rules (for badges or points) for current
  # 'controller_path#action_name'
  module ControllerExtensions
    def self.included(base)
      base.after_filter do |controller|
        if rules_defined?
          log_merit_action
          Merit::Action.check_unprocessed if Merit.checks_on_each_request
        end
      end
    end

    private

    def log_merit_action
      Merit::Action.create(
        user_id:       send(Merit.current_user_method).try(:id),
        action_method: action_name,
        action_value:  params[:value],
        had_errors:    had_errors?,
        target_model:  controller_path,
        target_id:     target_id
      ).id
    end

    def rules_defined?
      RulesMatcher.new(controller_path, action_name).any_matching?
    end

    def had_errors?
      target_object.respond_to?(:errors) && target_object.errors.try(:present?)
    end

    def target_object
      target_obj = instance_variable_get(:"@#{controller_name.singularize}")
      if target_obj.nil?
        str = '[merit] No object found, you might need a ' \
          "'@#{controller_name.singularize}' variable in " \
          "'#{controller_path}_controller' if no reputation is applied. " \
          'If you are using `model_name` option in the rule this is ok.'
        Rails.logger.warn str
      end
      target_obj
    end

    def target_id
      target_id = target_object.try(:id)
      # If target_id is nil
      # then use params[:id].
      if target_id.nil? && send("check_#{Merit.orm}_id", params[:id])
        target_id = params[:id]
      end
      target_id
    end

    # This check avoids trying to set a slug as integer FK
    def check_active_record_id(id)
      id.to_s =~ /^[0-9]+$/
    end

    def check_mongoid_id(id)
      id.to_s =~ /^[0-9a-fA-F]{24}$/
    end
  end
end
