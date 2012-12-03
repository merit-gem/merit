require "merit/models/#{Merit.orm}/merit/action"

# Merit::Action general schema
#   ______________________________________________________________
#   source  | action       | target
#   user_id | method,value | model,id | processed
#   ______________________________________________________________
#   1 | comment nil | List 8  | true
#   1 | vote 3      | List 12 | true
#   3 | follow nil  | User 1  | false
#   X | create nil  | User #{generated_id} | false
#   ______________________________________________________________
#
# Rules relate to merit_actions by action name ('controller#action' string)
module Merit
  class Action
    attr_accessible :user_id, :action_method, :action_value, :had_errors,
      :target_model, :target_id, :processed, :log

    def self.check_unprocessed_rules
      where(:processed => false).map &:check_all_rules
    end

    # Check rules defined for a merit_action
    def check_all_rules
      processed!
      return if had_errors

      badge_rules = ::Merit::AppBadgeRules[action_str] || []
      point_rules = ::Merit::AppPointRules[action_str] || []
      check_rules badge_rules, :badges
      check_rules point_rules, :points
    end

    def log_activity(str)
      self.update_attribute :log, "#{self.log}#{str}|"
    end

    def target_object(model_name = nil)
      # Grab custom model_name from Rule, or target_model from Merit::Action triggered
      klass = model_name || target_model
      klass.singularize.camelize.constantize.find_by_id(target_id)
    rescue => e
      Rails.logger.warn "[merit] no target_obj found: #{e}"
    end

    private

    def check_rules(rules_array, badges_or_points)
      rules_array.each do |rule|
        judge = Judge.new sash_to_badge(rule), rule, :action => self
        judge.send :"apply_#{badges_or_points}"
      end
    end

    # Subject to badge: source_user or target.user?
    def sash_to_badge(rule)
      if rule.to == :itself
        target = target_object(rule.model_name)
      else
        target = target(rule.to)
      end
      target.try(:_sash)
    end

    def target(to)
      (to == :action_user) ? action_user : other_target(to)
    end

    def action_str
      "#{target_model}\##{action_method}"
    end

    def action_user
      begin
        Merit.user_model.find(user_id)
      rescue ActiveRecord::RecordNotFound
        Rails.logger.warn "[merit] no #{Merit.user_model} found with id #{user_id}"
        return
      end
    end

    def other_target(to)
      begin
        target_object.send(to)
      rescue NoMethodError
        Rails.logger.warn "[merit] NoMethodError on '#{target_object.inspect}.#{to}' (called from Merit::Action#other_target)"
        return
      end
    end

    # Mark merit_action as processed
    def processed!
      self.processed = true
      self.save
    end
  end
end
