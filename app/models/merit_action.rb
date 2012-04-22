require "merit/models/#{Merit.orm}/merit_action"

class MeritAction
  # Check rules defined for a merit_action
  def check_rules(defined_rules)
    action_name = "#{target_model}\##{action_method}"

    unless had_errors
      # Check Badge rules
      if defined_rules[action_name].present?
        defined_rules[action_name].each do |rule|
          rule.grant_or_delete_badge(self)
        end
      end

      # Check Point rules
      actions_to_point = Merit::PointRules.new.actions_to_point
      if actions_to_point[action_name].present?
        point_rule = actions_to_point[action_name]
        point_rule[:to].each do |to|
          if to == :action_user
            if !(target = User.find_by_id(user_id))
              Rails.logger.warn "[merit] no user found to grant points"
              return
            end
          else
            begin
              target = target_object.send(to)
            rescue NoMethodError
              Rails.logger.warn "[merit] No target_object found on check_rules."
              return
            end
          end
          target.update_attribute(:points, target.points + point_rule[:score])
          log!("points_granted:#{point_rule[:score]}")
        end
      end
    end

    processed!
  end

  # Action's target object
  def target_object(model_name = nil)
    # Grab custom model_name from Rule, or target_model from MeritAction triggered
    klass = model_name || target_model
    klass.singularize.camelize.constantize.find_by_id(target_id)
  end

  def log!(str)
    self.update_attribute :log, "#{self.log}#{str}|"
  end

  # Mark merit_action as processed
  def processed!
    self.update_attribute :processed, true
  end
end
