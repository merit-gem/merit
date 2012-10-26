module Merit
  # Points are a simple integer value which are given to "meritable" resources
  # according to rules in +app/models/merit/point_rules.rb+. They are given on
  # actions-triggered.
  module PointRulesMethods
    # Define rules on certaing actions for giving points
    def score(points, *args, &block)
      options = args.extract_options!
      options[:to] ||= [:action_user]

      actions = Array.wrap(options[:on])

      Array.wrap(options[:to]).each do |to|
        rule = Rule.new
        rule.score = points
        rule.to    = to
        rule.block = block

        actions.each do |action|
          actions_to_point[action] ||= []
          actions_to_point[action] << rule
        end
      end
    end

    # Currently defined rules
    def actions_to_point
      @actions_to_point ||= {}
    end
  end
end
