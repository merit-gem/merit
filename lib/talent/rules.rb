module Talent
  module Rules
    # Grant badge to user if applies
    def grant_on(action, *args, &block)
      options = args.extract_options!
      talent_rules[action] ||= []
      talent_rules[action] << {
        :badge  => options[:badge],
        :level  => options[:level],
        :block  => block
      }
      Rails.logger.warn "TALENT: Added rule for #{action}."
    end

    def check_last_actions
      last_id = TalentAction.last.id
      # FIXME: where(:id => [last_action_checked..last_id])
      # "Arel error: Can't visit range". Why isn't it working with range?
      TalentAction.where("#{last_action_checked} < id AND id <= #{last_id}").each do |action|
        check_rules(action)
      end
      last_action_checked = last_id
    end

    def check_rules(action)
      action_name = "#{action.target_model}\##{action.action_method}"
      talent_rules[action_name].each do |rule|
        Rails.logger.warn "TALENT: Checking #{talent_rules[action_name].count} rules for #{action_name}..."
        user  = User.find(action.user_id)
        badge = Badge.where(:name => rule[:badge], :level => rule[:level]).first
        if rule[:block].call && !user.badges.include?(badge)
          user.badges << badge
          user.save
          Rails.logger.warn "TALENT: Granted badge #{badge.name}-#{badge.level} to #{user.name}!"
        end
      end unless talent_rules[action_name].nil?
    end

    def talent_rules
      @talent_rules ||= {}
    end

    def last_action_checked
      @last_action_checked ||= 0
    end

    def last_action_checked=(last_id)
      @last_action_checked = last_id
    end
  end
end