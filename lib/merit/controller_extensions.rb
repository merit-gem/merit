module Merit
  # This module sets up an after_filter to update merit_actions table.
  # It executes on every action, and checks rules only if
  # 'controller_name#action_name' has defined badge or point rules
  module ControllerExtensions
    def self.included(base)
      base.after_filter do |controller|
        action      = "#{controller_name}\##{action_name}"
        badge_rules = BadgeRules.new
        point_rules = PointRules.new
        if badge_rules.defined_rules[action].present? || point_rules.defined_rules[action].present?
          merit_action_id = MeritAction.create(
            :user_id       => send(Merit.current_user_method).try(:id),
            :action_method => action_name,
            :action_value  => params[:value],
            :had_errors    => target_object.try(:errors).try(:present?) || false,
            :target_model  => controller_name,
            :target_id     => target_id
          ).id

          # Check rules in after_filter?
          if Merit.checks_on_each_request
            badge_rules.check_new_actions
          end
        end
      end
    end

    def target_object
      target_obj = instance_variable_get(:"@#{controller_name.singularize}")
      if target_obj.nil?
        Rails.logger.warn("[merit] No object found, maybe you need a '@#{controller_name.singularize}' variable in '#{controller_name}_controller'?")
      end
      target_obj
    end

    def target_id
      target_id = params[:id] || target_object.try(:id)
      # using friendly_id if id nil or string (), and target_object found
      if target_object.present? && (target_id.nil? || !(target_id =~ /^[0-9]+$/))
        target_id = target_object.id
      end
      target_id
    end
  end
end
