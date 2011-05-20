class TalentAction < ActiveRecord::Base
  # Check rules defined for a talent_action
  def check_rules(defined_rules)
    action_name = "#{self.target_model}\##{self.action_method}"
    defined_rules[action_name].each do |rule|
      user = self.user_to_badge(rule)
      if rule.applies?(self.target_object) && !user.badges.include?(rule.badge)
        user.badges << rule.badge
        user.save
        Rails.logger.warn "TALENT: Granted badge #{rule.badge.name}-#{rule.badge.level} to #{user.name}!"
      end
    end unless defined_rules[action_name].nil?
    self.processed!
  end

  # Subject to badge: source_user or target.user?
  def user_to_badge(rule)
    related_user = rule.to == 'related_user' && !target_object.user.nil?
    related_user ? self.target_object.user : User.find(self.user_id)
  end

  # Action's target object
  def target_object
    target_model = self.target_model.singularize.camelize.constantize
    target_model.find(self.target_id) unless self.target_id.nil?
  end

  # Mark talent_action as processed
  def processed!
    self.processed = true
    self.save
  end
end