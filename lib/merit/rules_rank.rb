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

    # Check rules defined for a merit_action
    def check_rank_rules
      defined_rules.each do |scoped_model, level_and_rules|
        level_and_rules = level_and_rules.sort
        level_and_rules.each do |level, rule|
          begin
            items = []
            if Merit.orm == :mongoid
              items = scoped_model.where(:"#{rule.level_name}".lt => level)
            else
              items = scoped_model.where("#{rule.level_name} < #{level}")
            end
            items.each do |obj|
              if rule.applies?(obj)
                obj.update_attribute rule.level_name, level
              end
            end
          rescue ActiveRecord::StatementInvalid
            Rails.logger.warn "[merit] Please add #{rule.level_name} column/attribute to #{scoped_model.new.class.name}"
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