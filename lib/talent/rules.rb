module Talent
  module Rules
    class Rule
      attr_accessor :badge, :level, :to, :block

      def applies?(user, target_obj, badge)
        is_true = true # no block given?
        unless self.block.nil?
          # FIXME: Are they different objects? http://stackoverflow.com/questions/6002839/initialize-two-variables-on-same-line
          is_true = called = self.block.call # evaluates to true?
          if called.kind_of?(Hash)
            called.each do |method, value|
              is_true = is_true && target_obj.send(method) == value # target_obj responds what's expected?
            end
          end
        end
        # No block, or it's true, or target_obj responds what Hash expects,
        # badge exists, and target user doesn't have it
        is_true && !badge.nil? && !user.badges.include?(badge)
      end
    end

    # Grant badge to user if applies
    def grant_on(action, *args, &block)
      options = args.extract_options!
      talent_rules[action] ||= []

      # FIXME: Better way to initialize object, like hash style?
      rule = Rule.new
      rule.badge = options[:badge]
      rule.level = options[:level]
      rule.to    = options[:to] || 'action_user'
      rule.block = block

      talent_rules[action] << rule
      Rails.logger.warn "TALENT: Added rule for #{action}."
    end

    def check_new_actions
      TalentAction.where(:processed => false).each do |talent_action|
        talent_action.check_rules(talent_rules)
      end
    end

    def talent_rules
      @talent_rules ||= {}
    end
  end
end