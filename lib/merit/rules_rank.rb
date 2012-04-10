module Merit
  # 5 stars is a common ranking use case. They are not given at specified
  # actions like badges, you should define a cron job to test if ranks are to be
  # granted.
  #
  # +set_rank+ accepts:
  # * :+level+ ranking level (greater is better)
  # * :+to+ model or scope to check if new rankings apply
  module RankRules
    # Populates +defined_rules+ hash with following hierarchy:
    #   defined_rules[ModelToRank] = { levels => blocks }
    def set_rank(*args, &block)
      options = args.extract_options!

      # TODO: Design smell: Using Rule only for block and #applies?
      rule = Rule.new
      rule.block = block

      defined_rules[options[:to]] ||= {}
      defined_rules[options[:to]].merge!({ options[:level] => rule })
    end

    # Check rules defined for a merit_action
    def check_rank_rules
      defined_rules.each do |scoped_model, level_and_rules|
        level_and_rules = level_and_rules.sort
        level_and_rules.each do |level, rule|
          scoped_model.where("level < #{level}").each do |obj|
            if rule.applies?(obj)
              obj.update_attribute :level, level
            end
          end
        end
      end
    end

    # Currently defined rules
    def defined_rules
      @defined_rules ||= {}
    end
  end
end