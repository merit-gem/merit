module Merit
  # Points are a simple integer value which are given to "meritable" resources
  # according to rules in +app/models/merit_point_rules.rb+. They are given on
  # actions-triggered.
  class PointRules
    # Define rules on certaing actions for giving points
    def score(points, *args, &block)
      options = args.extract_options!

      actions = options[:on].kind_of?(Array) ? options[:on] : [options[:on]]
      options[:to] ||= [:action_user]
      targets = options[:to].kind_of?(Array) ? options[:to] : [options[:to]]
      actions.each do |action|
        actions_to_point[action] = {
          :to => targets,
          :score => points
        }
      end
    end

    # Currently defined rules
    def actions_to_point
      @actions_to_point ||= {}
    end
  end
end