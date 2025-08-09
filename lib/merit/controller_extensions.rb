module Merit
  # Sets up an app-wide after_filter, and inserts merit_action entries if
  # there are defined rules (for badges or points) for current
  # 'controller_path#action_name'
  module ControllerExtensions
    def self.included(base)
      base.after_action :log_and_process
    end

    private

    def log_and_process
      if rules_defined?
        Merit::Action.create(merit_action_hash)

        if Merit.checks_on_each_request
          Merit::Action.check_unprocessed
        end
      end
    end

    def merit_action_hash
      {
        user_id:       send(Merit.current_user_method).try(:id),
        action_method: action_name,
        action_value:  params[:value],
        had_errors:    had_errors?,
        target_model:  controller_path,
        target_id:     target_id,
        target_data:   JSON.generate(target_object.as_json)
      }
    end

    def rules_defined?
      RulesMatcher.new(controller_path, action_name).any_matching?
    end

    def had_errors?
      target_object.respond_to?(:errors) && target_object.errors.try(:present?)
    end

    def target_object
      variable_name = :"@#{controller_name.singularize}"
      if instance_variable_defined?(variable_name)
        if (target_obj = instance_variable_get(variable_name))
          target_obj
        else
          warn_no_object_found
        end
      end
    end

    def warn_no_object_found
      str = '[merit] No object found, you might need a ' \
        "'@#{controller_name.singularize}' variable in " \
        "'#{controller_path}_controller' if no reputation is applied. " \
        'If you are using `model_name` option in the rule this is ok.'
      Rails.logger.warn str
      nil
    end

    def target_id
      target_id = target_object.try(:id)
      # If target_id is nil use (only digits of) params[:id]
      if target_id.nil? && params[:id].to_s =~ /^[0-9]+$/
        target_id = params[:id]
      end
      target_id
    end
  end
end
