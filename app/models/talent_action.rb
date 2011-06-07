class TalentAction < ActiveRecord::Base
  # Check rules defined for a talent_action
  def check_rules(defined_rules)
    action_name = "#{target_model}\##{action_method}"
    unless defined_rules[action_name].nil?
      defined_rules[action_name].each do |rule|
        grant_or_delete_badge(rule)
      end
    end
    processed!
  end

  # Grant badge if rule applies. If it doesn't, and the badge is temporary,
  # then remove it.
  def grant_or_delete_badge(rule)
    receiver = user_to_badge(rule)
    if rule.applies? target_object
      rule.badge.grant_to(receiver)
    elsif rule.temporary?
      receiver.badges -= [rule.badge]
      receiver.save
    end
  end

  # Subject to badge: source_user or target.user?
  def user_to_badge(rule)
    related_user = rule.to == :related_user && !target_object.user.nil?
    related_user ? target_object.user : User.find(user_id)
  end

  # Action's target object
  def target_object
    klass = target_model.singularize.camelize.constantize
    klass.find(target_id) unless target_id.nil?
  end

  # Mark talent_action as processed
  def processed!
    processed = true
    save
  end
end
