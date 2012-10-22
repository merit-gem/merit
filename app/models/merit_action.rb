require "merit/models/#{Merit.orm}/merit_action"

class MeritAction
  attr_accessible :user_id, :action_method, :action_value, :had_errors,
    :target_model, :target_id, :processed, :log

  # Check rules defined for a merit_action
  def check_rules
    unless had_errors
      check_badge_rules
      check_point_rules
    end
    processed!
  end

  def check_badge_rules
    return if badge_rules.nil?
    badge_rules.each { |rule| rule.grant_or_delete_badge(self) }
  end

  def check_point_rules
    return if point_rules.nil?
    category ||= 'default' # Will be configurable

    point_rules.each do |point_rule|
      point_rule[:to].each do |to|
        sash = target(to).sash
        point = Merit::Score::Point.new
        point.num_points = point_rule[:score]
        point.log        = point_rule.inspect # TODO
        sash.scores.where(:category => category).first.score_points << point
        log!("points_granted:#{point_rule[:score]}")
      end
    end
  end


  def badge_rules
    @badge_rules ||= Merit::BadgeRules.new.defined_rules[action_str] || []
  end
  def point_rules
    @point_rules ||= Merit::PointRules.new.actions_to_point[action_str] || []
  end
  def action_str
    "#{target_model}\##{action_method}"
  end

  def target(to)
    @target ||= (to == :action_user) ? action_user : other_target(to)
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
      Rails.logger.warn "[merit] No target_object found on check_rules."
      return
    end
  end

  # Action's target object
  def target_object(model_name = nil)
    # Grab custom model_name from Rule, or target_model from MeritAction triggered
    klass = model_name || target_model
    klass.singularize.camelize.constantize.find_by_id(target_id)
  rescue => e
    Rails.logger.warn "[merit] no target_object found: #{e}"
  end

  def log!(str)
    self.log = "#{self.log}#{str}|"
    self.save
  end

  # Mark merit_action as processed
  def processed!
    self.processed = true
    self.save
  end
end
