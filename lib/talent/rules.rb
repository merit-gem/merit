module Talent
  module Rules
    # Grant badge to user if applies
    def grant_on(action, *args, &block)
      options = args.extract_options!
      talent_rules[action] ||= []
      talent_rules[action] << {
        :badge  => options[:badge],
        :level  => options[:level],
        :to     => options[:to] || 'action_user',
        :block  => block
      }
      Rails.logger.warn "TALENT: Added rule for #{action}."
    end

    def check_new_actions
      TalentAction.where(:processed => false).each do |action|
        check_rules(action)
        action.processed!
      end
    end

    def check_rules(action)
      action_name = "#{action.target_model}\##{action.action_method}"
      talent_rules[action_name].each do |rule|
        Rails.logger.warn "TALENT: Checking #{talent_rules[action_name].count} rules for #{action_name} to #{rule[:to]}..."

        # Subject to badge: source_user or target.user?
        target_model  = action.target_model.singularize.camelize.constantize
        target_object = target_model.find(action.target_id) unless action.target_id.nil?
        related_user  = rule[:to] == 'related_user' && !target_object.user.nil?
        user = related_user ? target_object.user : User.find(action.user_id)

        # Find badge to (possibly) apply
        badge = Badge.where(:name => rule[:badge])
        badge = badge.where(:level => rule[:level]) unless rule[:level].nil?
        badge = badge.first

        if rule_applies?(rule, user, target_object, badge)
          user.badges << badge
          user.save
          Rails.logger.warn "TALENT: Granted badge #{badge.name}-#{badge.level} to #{user.name}!"
        end
      end unless talent_rules[action_name].nil?
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

    def talent_rules
      @talent_rules ||= {}
    end
  end
end