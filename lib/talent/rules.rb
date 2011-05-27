module Talent
  module Rules
    # Define rule for granting badges
    def grant_on(action, *args, &block)
      options = args.extract_options!
      defined_rules[action] ||= []

      rule = Rule.new
      rule.badge_name = options[:badge]
      rule.level = options[:level]
      rule.to    = options[:to] || :action_user
      rule.block = block

      defined_rules[action] << rule
    end

    # Check non processed actions and grant badges if applies
    def check_new_actions
      TalentAction.where(:processed => false).each do |talent_action|
        talent_action.check_rules(defined_rules)
      end
    end

    # Currently defined rules
    def defined_rules
      @defined_rules ||= {}
    end
  end
end