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
      where(processed: false).find_each(&:check_all_rules)
    end

    # Check rules defined for a merit_action
    def check_all_rules
      mark_as_processed!
      return if had_errors

      check_rules rules_matcher.select_from(AppBadgeRules), :badges
      check_rules rules_matcher.select_from(AppPointRules), :points
    end

    private

    def check_rules(rules_array, badges_or_points)
      rules_array.each do |rule|
        judge = Judge.new rule, action: self
        judge.send :"apply_#{badges_or_points}"
      end
    end

    def mark_as_processed!
      self.processed = true
      save
    end

    def rules_matcher
      @rules_matcher ||= ::Merit::RulesMatcher.new(target_model, action_method)
    end
  end
end
