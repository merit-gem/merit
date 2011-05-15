module Talent
  module Rules
    # Grant badge to user if applies
    def grant_on(action, *args, &block)
      options = args.extract_options!
      talent_rules[action] ||= []
      talent_rules[action] << {
        :badge  => options[:badge],
        :level  => options[:level],
        :to     => options[:to] || 'action_user',
        :block  => block
      }
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