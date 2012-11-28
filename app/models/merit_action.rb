require "merit/models/#{Merit.orm}/merit_action"

# MeritAction general schema
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
class MeritAction
  attr_accessible :user_id, :action_method, :action_value, :had_errors,
    :target_model, :target_id, :processed, :log

  def self.check_unprocessed_rules
    where(:processed => false).map &:check_rules
  end

  # Check rules defined for a merit_action
  def check_rules
    unless had_errors
      check_badge_rules
      check_point_rules
    end
    processed!
  end

  def target(to)
    @target ||= (to == :action_user) ? action_user : other_target(to)
  end

  def target_object(model_name = nil)
    # Grab custom model_name from Rule, or target_model from MeritAction triggered
    klass = model_name || target_model
    klass.singularize.camelize.constantize.find_by_id(target_id)
  rescue => e
    Rails.logger.warn "[merit] no target_object found: #{e}"
  end

  def log_activity(str)
    self.update_attribute :log, "#{self.log}#{str}|"
  end

  private

  def check_badge_rules
    badge_rules = Merit::BadgeRules.new.defined_rules[action_str] || []
    badge_rules.each { |rule| rule.apply_badges(self) }
  end

  def check_point_rules
    point_rules = Merit::PointRules.new.defined_rules[action_str] || []
    point_rules.each { |rule| rule.apply_points(self) }
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
      Rails.logger.warn "[merit] NoMethodError on '#{target_object.inspect}.#{to}' (called from MeritAction#other_target)"
      return
    end
  end

  # Mark merit_action as processed
  def processed!
    self.processed = true
    self.save
  end
end
