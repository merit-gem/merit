module Merit
  module BadgeRulesMethods
    # Define rule for granting badges
    def grant_on(actions, *args, &block)
      options = args.extract_options!

      actions = Array.wrap(actions)

      rule = Rule.new
      rule.badge_id   = options[:badge_id]
      rule.badge_name = options[:badge]
      rule.level      = options[:level]
      rule.to         = options[:to] || :action_user
      rule.multiple   = options[:multiple] || false
      rule.temporary  = options[:temporary] || false
      rule.model_name = options[:model_name] || actions.first.split('#').first
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
