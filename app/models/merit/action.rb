require_dependency "merit/models/#{Merit.orm}/merit/action"

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
    def self.check_unprocessed
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

    private

    def check_rules(rules_array, badges_or_points)
      rules_array.each do |rule|
        judge = Judge.new sashes_to_badge(rule), rule, :action => self
        judge.send :"apply_#{badges_or_points}"
      end
    end

    # Subject to badge: source_user or target.user?
    def sashes_to_badge(rule)
      SashFinder.find(rule, self)
    end

    def action_str
      "#{target_model}\##{action_method}"
    end

    # Mark merit_action as processed
    def processed!
      self.processed = true
      self.save
    end
  end
end
