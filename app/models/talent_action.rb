class TalentAction < ActiveRecord::Base
  # Check rules defined for a talent_action
  def check_rules(talent_rules)
    action_name = "#{self.target_model}\##{self.action_method}"
    talent_rules[action_name].each do |rule|
      Rails.logger.warn "TALENT: Checking #{talent_rules[action_name].count} rules for #{action_name} to #{rule[:to]}..."

      # Subject to badge: source_user or target.user?
      target_model  = self.target_model.singularize.camelize.constantize
      target_object = target_model.find(self.target_id) unless self.target_id.nil?
      related_user  = rule[:to] == 'related_user' && !target_object.user.nil?
      user = related_user ? target_object.user : User.find(self.user_id)

      # Find badge to (possibly) apply
      badges = Badge.where(:name => rule[:badge])
      badges = badges.where(:level => rule[:level]) unless rule[:level].nil?
      badge = badges.first

      if self.rule_applies?(rule, user, target_object, badge) # FIXME: Should be rule.applies, define class Rule?
        user.badges << badge
        user.save
        Rails.logger.warn "TALENT: Granted badge #{badge.name}-#{badge.level} to #{user.name}!"
      end
    end unless talent_rules[action_name].nil?
    self.processed!
  end

  def rule_applies?(rule, user, target_obj, badge)
    is_true = true # no block given?
    unless rule[:block].nil?
      # FIXME: Are they different objects? http://stackoverflow.com/questions/6002839/initialize-two-variables-on-same-line
      is_true = called = rule[:block].call # evaluates to true?
      if called.kind_of?(Hash)
        called.each do |method, value|
          is_true = is_true && target_obj.send(method) == value # target_obj responds what's expected?
        end
      end
    end
    # No block, or it's true, or target_obj responds what Hash expects,
    # badge exists, and target user doesn't have it
    is_true && !badge.nil? && !user.badges.include?(badge)
  end

  # Mark talent_action as processed
  def processed!
    self.processed = true
    self.save
  end
end