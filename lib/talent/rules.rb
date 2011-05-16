module Talent
  module Rules
    class Rule
      attr_accessor :badge_name, :level, :to, :block

      def applies?(target_obj)
        # no block given: always true
        no_block_or_true = true
        unless self.block.nil?
          # block evaluates to true?
          # FIXME: Are they different objects? http://stackoverflow.com/questions/6002839/initialize-two-variables-on-same-line
          no_block_or_true = called = self.block.call
          if called.kind_of?(Hash)
            # hash methods over target_obj respond what's expected?
            called.each do |method, value|
              no_block_or_true = no_block_or_true && target_obj.send(method) == value
            end
          end
        end
        no_block_or_true
      end

      def badge
        badges = Badge.where(:name => self.badge_name)
        badges = badges.where(:level => self.level) unless self.level.nil?
        badges.first
      end
    end

    # Grant badge to user if applies
    def grant_on(action, *args, &block)
      options = args.extract_options!
      talent_rules[action] ||= []

      # FIXME: Better way to initialize object, like hash style?
      rule = Rule.new
      rule.badge_name = options[:badge]
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