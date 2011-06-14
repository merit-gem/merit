module Merit
  module Rules
    # Define rule for granting badges
    def grant_on(action, *args, &block)
      options = args.extract_options!

      rule = Rule.new
      rule.badge_name = options[:badge]
      rule.level      = options[:level]
      rule.to         = options[:to] || :action_user
      rule.temporary  = options[:temporary] || false
      rule.block      = block

      defined_rules[action] ||= []
      defined_rules[action] << rule
    end

    # Check non processed actions and grant badges if applies
    def check_new_actions
      MeritAction.where(:processed => false).each do |merit_action|
        merit_action.check_rules(defined_rules)
      end
    end

    # Currently defined rules
    def defined_rules
      @defined_rules ||= {}
    end
  end
end