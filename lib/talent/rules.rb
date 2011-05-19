module Talent
  module Rules
    # Grant badge to user if applies
    def grant_on(action, *args, &block)
      options = args.extract_options!
      defined_rules[action] ||= []

      rule = Rule.new
      rule.badge_name = options[:badge]
      rule.level = options[:level]
      rule.to    = options[:to] || 'action_user'
      rule.block = block

      defined_rules[action] << rule
      Rails.logger.warn "TALENT: Added rule for #{action}."
    end

    def check_new_actions
      TalentAction.where(:processed => false).each do |talent_action|
        talent_action.check_rules(defined_rules)
      end
    end

    def defined_rules
      @defined_rules ||= {}
    end
  end
end