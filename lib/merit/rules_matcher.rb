module Merit
  class RulesMatcher
    def initialize(path, action_name)
      @path = path
      @action_name = action_name
    end

    def select_from(rules)
      rules.select do |glob, _|
        entire_path =~ /^#{Regexp.new(glob)}$/
      end.values.flatten
    end

    def any_matching?
      select_from(AppBadgeRules).any? || select_from(AppPointRules).any?
    end

    private

    def entire_path
      @entire_path ||= [@path, @action_name].join('#')
    end
  end
end
