module Merit
  # Rankings are very similar to badges. They give "badges" which have a hierarchy
  # defined by +level+'s lexicografical order (greater is better). If a rank is
  # granted, lower level ranks are taken off. 5 stars is a common ranking use
  # case.
  #
  # They are not given at specified actions like badges, you should define a cron
  # job to test if ranks are to be granted.
  #
  # +set_rank+ accepts:
  # * +badge_name+ name of this ranking
  # * :+level+ ranking level (greater is better)
  # * :+to+ model or scope to check if new rankings apply
  module RankRules
    # Populates +defined_rules+ hash with following hierarchy:
    #   defined_rules[ModelToRank][rankings] = [level, conditions_block]
    def set_rank(ranking, *args, &block)
      options = args.extract_options!

      rule = Rule.new
      rule.badge_name = ranking
      rule.level      = options[:level]
      rule.block      = block

      defined_rules[options[:to]] ||= {}
      defined_rules[options[:to]][ranking] ||= []
      defined_rules[options[:to]][ranking] << rule
    end

    # Check rules defined for a merit_action
    def check_rank_rules
      defined_rules.each do |scoped_model, rankings| # For each model
        rankings.each do |ranking, rules| # For each model's ranking (stars, etc)
          rules.each do |rule|            # For each ranking's rule (level)
            scoped_model.all.each {|obj| grant_rank(rule, obj) }
          end
        end
      end
    end

    # Grant rank if rule applies
    # Badge checks if it's rank is greater than sash's current one.
    def grant_rank(rule, target_object)
      if rule.applies? target_object
        rule.badge.grant_rank_to target_object.sash
      end
    end

    # Currently defined rules
    def defined_rules
      @defined_rules ||= {}
    end
  end
end