module Merit
  module BadgeRulesMethods
    # Define rule for granting badges
    def grant_on(action, *args, &block)
      options = args.extract_options!

      actions = Array.wrap(action)

      rule = Rule.new
      rule.badge_name = options[:badge]
      rule.level      = options[:level]
      rule.to         = options[:to] || :action_user
      rule.multiple   = options[:multiple] || false
      rule.temporary  = options[:temporary] || false
      rule.model_name = options[:model_name] || actions[0].split('#')[0]
      rule.block      = block

      actions.each do |action|
        defined_rules[action] ||= []
        defined_rules[action] << rule
      end
    end

    # Currently defined rules
    def defined_rules
      @defined_rules ||= {}
    end
  end
end
