module Merit
  # Points are a simple integer value which are given to "meritable" resources
  # according to rules in +app/models/merit/point_rules.rb+. They are given on
  # actions-triggered.
  module PointRulesMethods
    # Define rules on certaing actions for giving points
    def score(points, *args, &block)
      options = args.extract_options!
      options[:to] ||= :action_user
      options[:log] ||= 'Automatically granted'

      actions = Array.wrap(options[:on])

      Array.wrap(options[:to]).each do |to|
        rule = Rule.new
        rule.score = points
        rule.to    = to
        rule.block = block
        rule.log = options[:log]

        actions.each do |action|
          defined_rules[action] ||= []
          defined_rules[action] << rule
        end
      end
    end

    # Currently defined rules
    def defined_rules
      @defined_rules ||= {}
    end
  end
end
