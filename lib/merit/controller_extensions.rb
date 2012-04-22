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
        if badge_rules.defined_rules[action].present? || point_rules.actions_to_point[action].present?
          target_id = params[:id]
          # TODO: target_object should be configurable (now it's singularized controller name)
          target_object = instance_variable_get(:"@#{controller_name.singularize}")
          unless target_id =~ /^[0-9]+$/ # id nil, or string (friendly_id)?
            target_id = target_object.try(:id)
          end

          # TODO: value should be configurable (now it's params[:value] set in the controller)
          value = params[:value]
          MeritAction.create(
            :user_id       => current_user.try(:id),
            :action_method => action_name,
            :action_value  => value,
            :had_errors    => target_object.try(:errors).try(:present?),
            :target_model  => controller_name,
            :target_id     => target_id
          )

          # Check rules in after_filter?
          if Merit.checks_on_each_request
            badge_rules.check_new_actions
          end
        end
      end
    end
  end
end
