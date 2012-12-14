module Merit
  # 5 stars is a common ranking use case. They are not given at specified
  # actions like badges, you should define a cron job to test if ranks are to be
  # granted.
  #
  # +set_rank+ accepts:
  # * :+level+ ranking level (greater is better)
  # * :+to+ model or scope to check if new rankings apply
  # * :+level_name+ attribute name (default is empty and results in 'level'
  #   attribute, if set it's appended like 'level_#{level_name}')
  module RankRulesMethods
    # Populates +defined_rules+ hash with following hierarchy:
    #   defined_rules[ModelToRank] = { levels => blocks }
    def set_rank(*args, &block)
      options = args.extract_options!

      rule = Rule.new
      rule.block = block
      rule.level_name = options[:level_name].present? ? "level_#{options[:level_name]}" : 'level'

      defined_rules[options[:to]] ||= {}
      defined_rules[options[:to]].merge!({ options[:level] => rule })
    end

    # Not part of merit after_filter. To be called asynchronously:
    # Merit::RankRules.new.check_rank_rules
    def check_rank_rules
      defined_rules.each do |scoped_model, level_and_rules|
        level_and_rules.sort.each do |level, rule|
          grant_when_applies(scoped_model, rule, level)
        end
      end
    end

    # Currently defined rules
    def defined_rules
      @defined_rules ||= {}
    end

    private

    def grant_when_applies(scoped_model, rule, level)
      scope_to_promote(scoped_model, rule.level_name, level).each do |object|
        if rule.applies?(object)
          object.update_attribute rule.level_name, level
        end
      end
    rescue ActiveRecord::StatementInvalid => msg
      raise RankAttributeNotDefined, "Add #{rule.level_name} column to #{scoped_model.new.class.name}\n[#{msg}]"
    end

    def scope_to_promote(scope, level_name, level)
      if Merit.orm == :mongoid
        scope.where(:"#{level_name}".lt => level)
      else
        scope.where("#{level_name} < #{level}")
      end
    end
  end
end
