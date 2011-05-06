module Talent
  module Rules
    # Grant badge to user if applies
    def grant_on(action, *args, &block)
      options = args.extract_options!
      talent_rules[action] ||= []
      talent_rules[action] << {
        :badge  => options[:badge],
        :level  => options[:level],
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
        Rails.logger.warn "TALENT: Checking #{talent_rules[action_name].count} rules for #{action_name}..."
        user  = User.find(action.user_id)
        badge = Badge.where(:name => rule[:badge], :level => rule[:level]).first
        if rule[:block].call && !user.badges.include?(badge)
          user.badges << badge
          user.save
          Rails.logger.warn "TALENT: Granted badge #{badge.name}-#{badge.level} to #{user.name}!"
        end
      end unless talent_rules[action_name].nil?
    end

    def talent_rules
      @talent_rules ||= {}
    end
  end
end