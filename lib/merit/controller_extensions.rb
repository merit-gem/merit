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
          # id nil, or string (friendly_id); target_object found
          if target_object.present? && (target_id.nil? || !(target_id =~ /^[0-9]+$/))
            target_id = target_object.try(:id)
          end

          # TODO: value should be configurable (now it's params[:value] set in the controller)
          merit_action_id = MeritAction.create(
            :user_id       => current_user.try(:id),
            :action_method => action_name,
            :action_value  => params[:value],
            :had_errors    => target_object.try(:errors).try(:present?),
            :target_model  => controller_name,
            :target_id     => target_id
          )

          # Check rules in after_filter?
          if Merit.checks_on_each_request
            badge_rules.check_new_actions

            # Show flash msg?
            if (log = MeritAction.find(merit_action_id).log)
              # Badges granted to current_user
              granted = log.split('|').select{|log| log =~ /badge_granted_to_action_user/ }
              granted.each do |badge|
                badge_id = badge.split(':').last.to_i
                flash[:merit] = t('merit.flashs.badge_granted', badge: Badge.find(badge_id).name)
              end
            end
          end
        end
      end
    end
  end
end
