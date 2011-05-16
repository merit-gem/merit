class TalentAction < ActiveRecord::Base
  # Check rules defined for a talent_action
  def check_rules(talent_rules)
    action_name = "#{self.target_model}\##{self.action_method}"
    talent_rules[action_name].each do |rule|
      Rails.logger.warn "TALENT: Checking #{talent_rules[action_name].count} rules for #{action_name} to #{rule.to}..."

      # Subject to badge: source_user or target.user?
      target_model  = self.target_model.singularize.camelize.constantize
      target_object = target_model.find(self.target_id) unless self.target_id.nil?
      related_user  = rule.to == 'related_user' && !target_object.user.nil?
      user = related_user ? target_object.user : User.find(self.user_id)

      if rule.applies?(target_object) && !user.badges.include?(rule.badge)
        user.badges << rule.badge
        user.save
        Rails.logger.warn "TALENT: Granted badge #{rule.badge.name}-#{rule.badge.level} to #{user.name}!"
      end
    end unless talent_rules[action_name].nil?
    self.processed!
  end

  # Mark talent_action as processed
  def processed!
    self.processed = true
    self.save
  end
end