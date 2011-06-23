class MeritAction < ActiveRecord::Base
  # Check rules defined for a merit_action
  def check_badge_rules(defined_rules)
    action_name = "#{target_model}\##{action_method}"
    unless defined_rules[action_name].nil?
      defined_rules[action_name].each do |rule|
        rule.grant_or_delete_badge(self)
      end
    end
    processed!
  end

  # Action's target object
  def target_object
    klass = target_model.singularize.camelize.constantize
    klass.find(target_id) unless target_id.nil?
  end

  # Mark merit_action as processed
  def processed!
    processed = true
    save
  end
end
